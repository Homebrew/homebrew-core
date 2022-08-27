class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/9.1.0.tar.gz"
  sha256 "5dea48d1fcddc3ec571ce2058e13910a0d4a6bab4cc09a809d8b1dd1c88ae6f2"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "874c6516db35f84fa5570ad821a41e4cc6273f33db0b47db51cc9f74c86eef7a"
    sha256 cellar: :any,                 arm64_big_sur:  "279ffdb934f456f8f92bba5328a626b21a25dd2625d2cfaa5eb3858910c85d3d"
    sha256 cellar: :any,                 monterey:       "05bdf220753ccd28c98b0b83fc039e36588bd913f5e495cc61283f9e5ff339ba"
    sha256 cellar: :any,                 big_sur:        "803d851c3003ebc7be27679e4210a1cfc8d1385486dc5ff33142a27d39b84054"
    sha256 cellar: :any,                 catalina:       "90b510bfb7c3544332afff9ece2057a4042d2756d98ac644872955b6458d19bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c565959b75715990c270eebd9e77d41ab8fe4ab46e8bb2dc836ee503f92ef0f7"
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
