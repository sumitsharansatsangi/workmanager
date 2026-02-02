import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:workmanager/workmanager.dart';

import 'workmanager_test.mocks.dart';

const testTaskName = 'ios-background-task-name';

Future<bool> testCallBackDispatcher(task, inputData) {
  return Future.value(true);
}

/// This replaces GetIt-based setup completely
void mySetUpWrapper(Workmanager workmanager) {
  workmanager.initialize(testCallBackDispatcher);
  workmanager.cancelAll();
  workmanager.cancelByUniqueName(testTaskName);
}

@GenerateMocks([Workmanager])
void main() {
  group("singleton pattern", () {
    test("It always returns the same Workmanager instance", () {
      final workmanager1 = Workmanager();
      final workmanager2 = Workmanager();

      expect(identical(workmanager1, workmanager2), true);
    });
  });

  group("mocked workmanager", () {
    late MockWorkmanager mockWorkmanager;

    setUp(() {
      mockWorkmanager = MockWorkmanager();
    });

    test("cancelAll - calls methods on mocked Workmanager", () {
      mySetUpWrapper(mockWorkmanager);

      verify(mockWorkmanager.initialize(testCallBackDispatcher)).called(1);
      verify(mockWorkmanager.cancelAll()).called(1);
    });

    test("cancelByUniqueName - calls methods on mocked Workmanager", () {
      mySetUpWrapper(mockWorkmanager);

      verify(mockWorkmanager.initialize(testCallBackDispatcher)).called(1);
      verify(
        mockWorkmanager.cancelByUniqueName(testTaskName),
      ).called(1);
    });
  });
}
