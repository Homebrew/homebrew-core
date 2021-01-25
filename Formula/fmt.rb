class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/7.1.3.tar.gz"
  sha256 "5cae7072042b3043e12d53d50ef404bbb76949dad1de368d7f993a15c8c05ecc"
  license "MIT"

  bottle do
    cellar :any
    sha256 "030400184b37be2dbefd79244622b6ba1db79a7a082063c9731422d67c1ec689" => :big_sur
    sha256 "ca7feb7f642cd97750e7df4a46229c5c8bf5948673a5b2be5cec24a4e4981ec3" => :arm64_big_sur
    sha256 "bc10923606cbc09de72d80d4fa35f2834cd3661791b493936a8d2853e571ef9d" => :catalina
    sha256 "9ff67f083520e388e629e37267b87099e2335ff8bedecd7662779f3042f11f3e" => :mojave
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
