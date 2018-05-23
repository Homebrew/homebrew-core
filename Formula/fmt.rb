class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/5.0.0.tar.gz"
  sha256 "fc33d64d5aa2739ad2ca1b128628a7fc1b7dca1ad077314f09affc57d59cf88a"

  bottle do
    cellar :any_skip_relocation
    sha256 "80917be53217006874322808d4d6a2edb2253e7410d3f1754298c538987f1a85" => :high_sierra
    sha256 "8f28bfe03fed314d9c2adab131f81bf9e8dac9fedf6081abec592a0940e9a156" => :sierra
    sha256 "8934d55f678848b97388beb25141e4704938b99947754ba26b330a100740a311" => :el_capitan
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
