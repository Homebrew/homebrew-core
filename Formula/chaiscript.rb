class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "https://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.1.0.tar.gz"
  sha256 "3ca9ba6434b4f0123b5ab56433e3383b01244d9666c85c06cc116d7c41e8f92a"
  license "BSD-3-Clause"
  head "https://github.com/ChaiScript/ChaiScript.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6424e3a8c19e9c654db8954af3910392f6849bd0b6dfc4725ff62c757988d8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009f1ecb9cc7606337465866c209225a1282bda0bdef0a6bad35ba3e8582bad0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf3080dd47601b28622c198749587901d6d7eb59b5b3716a7bf72bc292be7cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "8a621c59024cf368be41bd03f834837b8473da66dbf3bdd8f5721fb3af3b0a67"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b2cadc6c93e131b1b46f2bb75a14b6b74c7ab89fac6a3165116c403d153c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "60056d2144073414ba1ad75e67b2ced0280a0596e5b7eea36d4475d5109f5c5b"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f971e8ca36046cb2ddfa59c4a39091bce3cb1178f2be35d4f5a7a98ec2c932"
    sha256 cellar: :any_skip_relocation, mojave:         "37f73c985ecbb3d1050f73c5020080fd6b8632780b3cacdc635c6198d9afd7d8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "905850906c705182fe0c3011314d52b852585121f91c91a03ad20cc1b4a1a830"
    sha256 cellar: :any_skip_relocation, sierra:         "ce45ec71bbf6917d01c5d3ac872b31637189b90216848166ec91df5c65a82d07"
    sha256 cellar: :any_skip_relocation, el_capitan:     "18a4b79b3b413b01d2801e0a49b054137c3307bc0fc930353b63e0746e43c16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34af5a03731cb336dad74d83505e8c9485092a275b632da30ca2d34a73d31461"
  end

  depends_on "cmake" => :build

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

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ldl", "-lpthread", "-std=c++14", "-o", "test"
    system "./test"
  end
end
