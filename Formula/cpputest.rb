class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "http://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz"
  sha256 "c81dccc5a1bfc7fc6511590c0a61def5f78e3fb19cb8e1f889d8d3395a476456"
  head "https://github.com/cpputest/cpputest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ad7b1baccaa82cc4774b77447e5cef3c71ddc039a37a2745021ad4a97a67eb2" => :el_capitan
    sha256 "0a423cd7875cf7e7e1d650b47fc81b2f609f7e4306e63939d8a8f73949bd38b7" => :yosemite
    sha256 "e20d81ca7436928b79328b32c19158def2e31da83b698531c71c6503cf6ff626" => :mavericks
    sha256 "dbde383c51725ef3fb71480f59627e64158c5639cb827e76d7c944b0d354fa9b" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "CppUTest/CommandLineTestRunner.h"
      int main(int ac, char** av)
      {
        return CommandLineTestRunner::RunAllTests(ac, av);
      }
    EOS
    system ENV.cxx, "test.cpp", "-lCppUTest", "-o", "test"
    assert_match /OK \(0 tests/, shell_output("./test")
  end
end
