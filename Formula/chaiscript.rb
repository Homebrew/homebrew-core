class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v5.8.3.tar.gz"
  sha256 "41f273c2c523c3456d40fae4766d165cc7ab9a764eebac7ff815929adf2c6b2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5641a2bffe5d45a6ff3dd3e826432a7026e9a6c50637178e14c0ffabc58b0695" => :sierra
    sha256 "c66a6b2d7629127266f8c841523ce59d0af2206ab35c4c6eac0e0892eb98bc3d" => :el_capitan
    sha256 "b5310616ab47a402874bfd2e40339fb2fb66733c39845e151ecd9a5b9232db43" => :yosemite
    sha256 "986e1030d25606a0f9ccf69d4c592c2d57dc64affd71b90dd6ee17cdadc81dbc" => :mavericks
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
