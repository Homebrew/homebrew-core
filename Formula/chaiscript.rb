class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v5.8.4.tar.gz"
  sha256 "924da6211809d5c9e4d7dcae484e146bcdc5cd169b1bb057b148b3aaaa47b635"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c1e350b3f902f83965a5e7e2b31b1294b7bdc2a4e674143c26990f83089228a" => :sierra
    sha256 "82dd9adc6cd69e2066a78e69c53a4277ce2576b482ff98e20addbe5b8f235430" => :el_capitan
    sha256 "5e5516164dc36cc84346d76ccfc88938c87070e1b6843468bd6f0d55f2c3807b" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <chaiscript/chaiscript.hpp>
      #include <chaiscript/chaiscript_stdlib.hpp>
      #include <cassert>
      int main() {
        chaiscript::ChaiScript chai(chaiscript::Std_Lib::library());
        assert(chai.eval<int>("123") == 123);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-std=c++11", "-o", "test"
    system "./test"
  end
end
