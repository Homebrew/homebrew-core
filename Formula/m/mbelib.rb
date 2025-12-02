class Mbelib < Formula
  desc "P25 Phase 1 and ProVoice vocoder"
  homepage "https://github.com/szechyjs/mbelib"
  url "https://github.com/szechyjs/mbelib/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5a2d5ca37cef3b6deddd5ce8c73918f27936c50eb0e63b27e4b4fc493310518d"
  license "ISC"
  head "https://github.com/szechyjs/mbelib.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fb72e50f6461676e8b9f0bc61ac16133652bc92e84a139f8db55db0f39952291"
    sha256 cellar: :any,                 arm64_sequoia:  "4303b80f4b00f9a5ba52109c0995c196d0d54b19f9d105520379206eb50b373c"
    sha256 cellar: :any,                 arm64_sonoma:   "cd9b0cc3c21687f175d3f4aee0229bd9b7aafe34eba6360f26f0619296a0acfe"
    sha256 cellar: :any,                 arm64_ventura:  "5efa031e17f6e6fbfa06cb1bab625af8721ec46b287044fa5cbb0e0567417a80"
    sha256 cellar: :any,                 arm64_monterey: "4a189fcd966e9a57fb11df30a7e136d98bd7b2e989d01af3731117475e2afc94"
    sha256 cellar: :any,                 arm64_big_sur:  "053dd044423318deba18dbccbbd1d85efec94b507dd5646beb7b6c3d32064010"
    sha256 cellar: :any,                 sonoma:         "2a453c236a4520b7dfc9e50e9fec24fdd2167c31b94b25ac1004b108c212ad14"
    sha256 cellar: :any,                 ventura:        "81eca52ffaa4828961e274c2c00ff39574ed1f9fddbc2d55fbea56068d2882e5"
    sha256 cellar: :any,                 monterey:       "925321b8a121e7cae27ec3736d1035d27d9945255ea9113f430c5dd15e7d4b7e"
    sha256 cellar: :any,                 big_sur:        "508ed0ed1f9603c7c3e50accea0e201d391f673b63a4acb71574827fddcbb1ef"
    sha256 cellar: :any,                 catalina:       "fb29c40fb9af7c0303d9f7929e61941e8c10c8aad57662f366a671d3a73be116"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bd598eb6c1483c8d083384b4e8edce2a37fbdebaf0efcfd7585f26440ffd66f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa416bb9571e03c0bb7b877a44f08e874f069367367ca6c3bd6cefb87ecd70d"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "test"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mb.cpp").write <<~CPP
      extern "C" {
      #include "mbelib.h"
      }
      int main() {
        float float_buf[160] = {1.23f, -1.12f, 4680.412f, 4800.12f, -4700.74f};
        mbe_synthesizeSilencef(float_buf);
        return (float_buf[0] != 0);
      }
    CPP
    system ENV.cxx, "mb.cpp", "-o", "test", "-L#{lib}", "-lmbe"
    system "./test"
  end
end
