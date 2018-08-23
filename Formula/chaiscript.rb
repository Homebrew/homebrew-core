class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "https://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.1.0.tar.gz"
  sha256 "3ca9ba6434b4f0123b5ab56433e3383b01244d9666c85c06cc116d7c41e8f92a"
  head "https://github.com/ChaiScript/ChaiScript.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "37f73c985ecbb3d1050f73c5020080fd6b8632780b3cacdc635c6198d9afd7d8" => :mojave
    sha256 "905850906c705182fe0c3011314d52b852585121f91c91a03ad20cc1b4a1a830" => :high_sierra
    sha256 "ce45ec71bbf6917d01c5d3ac872b31637189b90216848166ec91df5c65a82d07" => :sierra
    sha256 "18a4b79b3b413b01d2801e0a49b054137c3307bc0fc930353b63e0746e43c16d" => :el_capitan
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
