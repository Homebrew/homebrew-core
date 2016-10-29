class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v5.8.6.tar.gz"
  sha256 "05943d28d22785c44d9cb825a8efad9c3a5699447d7204ef9b53b1d64a9ac492"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad9e30d47610ad300013028ba5fed8a457e7a6e5fd0ddecad6005e06bd0da229" => :sierra
    sha256 "315f0164b410acb7d8f8be71bf34afac86c66341bf41f3e4881c2a5ce6826f9b" => :el_capitan
    sha256 "e3410f2c9e0d6d4c4c9d16ab1c4adbf8a4d86a17f20a3a40030a22826957ed0b" => :yosemite
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
