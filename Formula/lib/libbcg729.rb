class Libbcg729 < Formula
  desc "Encoder and decoder of the ITU G.729 Annex A/B speech codec"
  homepage "https://www.linphone.org"
  url "https://github.com/BelledonneCommunications/bcg729/archive/refs/tags/1.1.1.tar.gz"
  sha256 "68599a850535d1b182932b3f86558ac8a76d4b899a548183b062956c5fdc916d"
  license "GPL-3.0-only"
  head "https://github.com/BelledonneCommunications/bcg729.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e4e1023d647c56ecf56c914457736795151ecb9e5a8a999b152c7f0ba94b0c17"
    sha256 cellar: :any, arm64_sequoia: "3b4d947d803200cbed29549f73486c40b9e8a165ff342aaafc89ee62709f995c"
    sha256 cellar: :any, arm64_sonoma:  "e409d61660e8141ed2aa5ff59ca6118413a49408370ccff9a8387b85a7d0f970"
    sha256 cellar: :any, sonoma:        "2dc8be3037d5031e87c7662bdc3d654e93aa98f7336488f359191290a2fdd5b3"
    sha256 cellar: :any, arm64_linux:   "02565a286dfaaead294f1507c94008c485a1d5456eeea24d879ca12e3685bb67"
    sha256 cellar: :any, x86_64_linux:  "ad205694a774ab860904544c92d0f2fbf1ed8f7b5bcca99443215b84de75f842"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4. TODO: Remove next release.
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <bcg729/encoder.h>

      int main() {
        bcg729EncoderChannelContextStruct *enc = initBcg729EncoderChannel(0);
        if (!enc) return 1;

        closeBcg729EncoderChannel(enc);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test", "-lbcg729"
    system "./test"
  end
end
