class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "https://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "3ca9ba6434b4f0123b5ab56433e3383b01244d9666c85c06cc116d7c41e8f92a"
  license "BSD-3-Clause"
  head "https://github.com/ChaiScript/ChaiScript.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5a5e765882d43b75315f316297eca0a972b83c5e5c77c6b00bcc28ec4602bf64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "23f3944333ce9fa19f2664e512b9e6c98ba1e3dad79a9d409788ad2c70832494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cb81d66432b2941bf247d97c156f7764a7c4e76446691925b25cea785cd9f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6424e3a8c19e9c654db8954af3910392f6849bd0b6dfc4725ff62c757988d8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009f1ecb9cc7606337465866c209225a1282bda0bdef0a6bad35ba3e8582bad0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf3080dd47601b28622c198749587901d6d7eb59b5b3716a7bf72bc292be7cfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4acd72304685e0abc9b1cfe7d958377c1c67f428be643f08e027a4d8fbf283"
    sha256 cellar: :any_skip_relocation, ventura:        "8a621c59024cf368be41bd03f834837b8473da66dbf3bdd8f5721fb3af3b0a67"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b2cadc6c93e131b1b46f2bb75a14b6b74c7ab89fac6a3165116c403d153c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "60056d2144073414ba1ad75e67b2ced0280a0596e5b7eea36d4475d5109f5c5b"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f971e8ca36046cb2ddfa59c4a39091bce3cb1178f2be35d4f5a7a98ec2c932"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "48c885b02e7e02084d00622d66b9348f78a108ac315106752a19d5a0a58e65c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34af5a03731cb336dad74d83505e8c9485092a275b632da30ca2d34a73d31461"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <chaiscript/chaiscript.hpp>
      #include <chaiscript/chaiscript_stdlib.hpp>
      #include <cassert>

      int main() {
        chaiscript::ChaiScript chai;
        assert(chai.eval<int>("123") == 123);
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ldl", "-lpthread", "-std=c++14", "-o", "test"
    system "./test"
  end
end
