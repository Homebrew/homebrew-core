class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/refs/tags/10.1.1.tar.gz"
  sha256 "78b8c0a72b1c35e4443a7e308df52498252d1cefc2b08c9a97bc9ee6cfe61f8b"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4bd278eb5f9f8db13843573e727a0f3992064b49d46413171d7c1df6c01ae02"
    sha256 cellar: :any,                 arm64_ventura:  "87b7f569c29b6c91acf1bb7c2022d67186e932295c8611c1b94e071a0f07b513"
    sha256 cellar: :any,                 arm64_monterey: "25b3c5f7ff7eb92613836cf3efc9967ec31d85a4e947838833d98f3d99547c47"
    sha256 cellar: :any,                 arm64_big_sur:  "1567673afd845b6fcbe33561ff59de3d6eef379364ef0137d5ccd79ba5a26982"
    sha256 cellar: :any,                 sonoma:         "a2875c8d14b5f00735e850688f3c4f608c2d4ec60a75fdd8c7c03e88cc305585"
    sha256 cellar: :any,                 ventura:        "322e606bd2b921c777ae93857515cbe4dd308aeaf59a1b130ef9856b5ff22140"
    sha256 cellar: :any,                 monterey:       "8f03ab26e239eca36bffeaf984a779794832ece7aca7671687f694fd2468b546"
    sha256 cellar: :any,                 big_sur:        "9a6c2cdbdd62eb546c44789bd97828216c990e251d9aded16fda1526c099191d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b03e15d3b43614ea56c95232f4c116fc4ebaad6afbc4808cb0780a9c744563b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
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
