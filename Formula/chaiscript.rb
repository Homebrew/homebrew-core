class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.0.0.tar.gz"
  sha256 "ec4b51e30afbc5133675662882c59417a36aa607556ede7ca4736fab2b28c026"
  head "https://github.com/ChaiScript/ChaiScript.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5b137a9798ab0277ee7f0fa186319ce114ca4c1ef0e52ee61e3c3abb8fb7f2" => :high_sierra
    sha256 "0f69ef5b0abc817e48108d954c9db79400fda08318b93f2e512fb43183c04921" => :sierra
    sha256 "eea2d33732098ba3075a9011124d095f13359e182f2bed3e3fc27d47722262a6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
