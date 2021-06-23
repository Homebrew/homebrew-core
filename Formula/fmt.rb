class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz"
  sha256 "b06ca3130158c625848f3fb7418f235155a4d389b2abc3a6245fb01cb0eb1e01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ca7feb7f642cd97750e7df4a46229c5c8bf5948673a5b2be5cec24a4e4981ec3"
    sha256 cellar: :any,                 big_sur:       "030400184b37be2dbefd79244622b6ba1db79a7a082063c9731422d67c1ec689"
    sha256 cellar: :any,                 catalina:      "bc10923606cbc09de72d80d4fa35f2834cd3661791b493936a8d2853e571ef9d"
    sha256 cellar: :any,                 mojave:        "9ff67f083520e388e629e37267b87099e2335ff8bedecd7662779f3042f11f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c947ab1e8209f2b0c6734923136813a2ca221a34dce570d552cc09320e294373"
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
