class Asyncplusplus < Formula
  desc "Concurrency framework for C++11"
  homepage "https://github.com/Amanieu/asyncplusplus"
  url "https://github.com/Amanieu/asyncplusplus/archive/v1.1.tar.gz"
  sha256 "d160d3a433a1e08f51c785742843182c2b81a7bc872766f57bf5f3108377b858"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6d8ffe80f5931825874903e480010524c9ce2d3a2d3f19b0152897459748bf9"
    sha256 cellar: :any,                 arm64_big_sur:  "c44cc09dbae0270a7e13b87eb4a9e5b0af39ba3e7ba13032e37065014e621be9"
    sha256 cellar: :any,                 monterey:       "8f08fedb9006a57b2bf0a6af9a78bdf49fc742e47f2a9dc7af5cd34beb2d2ad0"
    sha256 cellar: :any,                 big_sur:        "c825975d9087a779f70d1daee59e259ac781353c0bdf169dc2255b19afaab447"
    sha256 cellar: :any,                 catalina:       "8116d1e5d9aefd7de88cb70633fdc91181460f7f0279bcc356f8d020a590510b"
    sha256 cellar: :any,                 mojave:         "805297c643ba0c1fe0d774ea606f6e0925112b1a364b74122c877d51f1e729fb"
    sha256 cellar: :any,                 high_sierra:    "ac6212a38c5aa391ee1eb547879615437a830967444deb15674e748c63f0b5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a9f2c4744ed1a2aca8a323ac6be7753bb3efd5fc4ac06ef999b7c99ada77ed"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lasync++", "--std=c++11", "-o", "test"
    assert_equal "10", shell_output("./test").chomp.lines.last
  end
end
