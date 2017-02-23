class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.0.0.tar.gz"
  sha256 "ec4b51e30afbc5133675662882c59417a36aa607556ede7ca4736fab2b28c026"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ab43c15675e41f22e6e40c3bbe26ae5acc42db43d7be50f9eb6f5a25c89311" => :sierra
    sha256 "e95df6e61bc1260f0773042a82b14f6a13cc69a13b632a3a032910175b230815" => :el_capitan
    sha256 "74ce285fe6b4a995f568f7bd89f4e7cc386d9b2202d4553ad3cf43c8091d4467" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

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
        chaiscript::ChaiScript chai;
        assert(chai.eval<int>("123") == 123);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-std=c++14", "-o", "test"
    system "./test"
  end
end
