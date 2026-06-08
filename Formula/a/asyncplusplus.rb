class Asyncplusplus < Formula
  desc "Concurrency framework for C++11"
  homepage "https://github.com/Amanieu/asyncplusplus"
  url "https://github.com/Amanieu/asyncplusplus/archive/refs/tags/v1.2.tar.gz"
  sha256 "0711c8db231bf3eb1066400f49ed73b5c3211a10eb3b8c3e64da3d5fdee8a4bf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dac09584a6d6b1fadb97f9a1fb4e439acc0c7dc9a33b24bef1fc5b32312d31e"
    sha256 cellar: :any,                 arm64_sequoia: "2f1f1563fd122b947f728ed73168c062ffb569adbc92f02e1bbd372edbdaf889"
    sha256 cellar: :any,                 arm64_sonoma:  "405f620fcdc1fd59da54ac754d28fa308c0f1abab3369dcfc77d2ee80b17fad5"
    sha256 cellar: :any,                 arm64_ventura: "2a2f1cdc93741e0db73b4359a7881225631f008a7b9e6e3d67d9d2de8d1c8765"
    sha256 cellar: :any,                 sonoma:        "251aea5c5562246a1ab1a394fa7396a4949df464c354f2007f4d671eee4a75be"
    sha256 cellar: :any,                 ventura:       "38434ba8c7542abbffd781b7f5f547f166f3143e971677d31bd1dd6a2c9da049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc17239cf85202f52390b6c1297bfd75db621c0dddb37d1df24366b0013538a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b9d42407804a993ea90e4e2cf04c0466ea226f4a967f1ac8b732d9bf830aec"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <async++.h>

      int main()
      {
          auto task1 = async::spawn([] {
              std::cout << "Task 1 executes asynchronously" << std::endl;
          });
          auto task2 = async::spawn([]() -> int {
              std::cout << "Task 2 executes in parallel with task 1" << std::endl;
              return 42;
          });
          auto task3 = task2.then([](int value) -> int {
              std::cout << "Task 3 executes after task 2, which returned "
                        << value << std::endl;
              return value * 3;
          });
          auto task4 = async::when_all(task1, task3);
          auto task5 = task4.then([](std::tuple<async::task<void>,
                                                async::task<int>> results) {
              std::cout << "Task 5 executes after tasks 1 and 3. Task 3 returned "
                        << std::get<1>(results).get() << std::endl;
          });

          task5.get();
          std::cout << "Task 5 has completed" << std::endl;

          async::parallel_invoke([] {
              std::cout << "This is executed in parallel..." << std::endl;
          }, [] {
              std::cout << "with this" << std::endl;
          });

          async::parallel_for(async::irange(0, 5), [](int x) {
              std::cout << x;
          });
          std::cout << std::endl;

          int r = async::parallel_reduce({1, 2, 3, 4}, 0, [](int x, int y) {
              return x + y;
          });
          std::cout << "The sum of {1, 2, 3, 4} is" << std::endl << r << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lasync++", "--std=c++11", "-o", "test"
    assert_equal "10", shell_output("./test").chomp.lines.last
  end
end
