class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.0.0.tar.gz"
  sha256 "f1907a58d5e86e6c382e51441d92ad9e23aea63827ba47fd647eacc0d3a16c78"

  bottle do
    cellar :any_skip_relocation
    sha256 "38059ee097c0e9f2e4a82c3b7a1185be2687906f47c6ff949a1dc3ce4075ce30" => :mojave
    sha256 "2d90c816fafe6abad75c7a44a42b6e32ad52f63e36b66efd4df7c61e639b9b4d" => :high_sierra
    sha256 "2504638eae813550df3dc1edd4025fc53483d69813e81630b62d2da6bf338b05" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
