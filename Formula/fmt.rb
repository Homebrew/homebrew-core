class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz"
  sha256 "b06ca3130158c625848f3fb7418f235155a4d389b2abc3a6245fb01cb0eb1e01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73db4f891010951987fe242ce0cdba2f81e0ac92ddbea69e58d7277a903da231"
    sha256 cellar: :any,                 arm64_big_sur:  "f9b84ce76a3226dc6f7e892b844de4238b1ea278bd77949839afbbc4b0bdce57"
    sha256 cellar: :any,                 monterey:       "e1906db10884e41bb0fbeb4bea9bab584ecbcc425a776047ec83032e870eab16"
    sha256 cellar: :any,                 big_sur:        "20e10af8ee859764717466c355812a03b4ed4e23b7e97f155b1bc0b391dfe2ba"
    sha256 cellar: :any,                 catalina:       "08d31cecf8c989a946b205aec6e5cb305f2982a59ea345ba343a4349cef998b7"
    sha256 cellar: :any,                 mojave:         "f0d905746ce5dc69067e240b33c2e37268c9f88889c65578fb96b7c373cc0e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4edba06a41ddb0fcea04cfb3b71c95dd945df125aee3d1de2f22abfa2b65fd6b"
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
