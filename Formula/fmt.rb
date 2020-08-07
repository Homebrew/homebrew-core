class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/7.0.2.tar.gz"
  sha256 "7697e022f9cdc4f90b5e0a409643faa2cde0a6312f85e575c8388a1913374de5"
  license "MIT"

  bottle do
    cellar :any
    sha256 "bb369479df40316b16565f935c091bbab2ba98e55be60ddec2528a6cdee72673" => :catalina
    sha256 "a46bd7e95d7ed4d8b54dc5c3badbd07c4863896dcf21774381bf6de9d6e12bfc" => :mojave
    sha256 "f2afe856eacf88c61b33299bbea2776b8317271b24f2d0a2e72a7aadb6e13da9" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
