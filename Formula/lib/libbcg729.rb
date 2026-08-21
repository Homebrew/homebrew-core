class Libbcg729 < Formula
  desc "Encoder and decoder of the ITU G.729 Annex A/B speech codec"
  homepage "https://www.linphone.org"
  url "https://github.com/BelledonneCommunications/bcg729/archive/refs/tags/1.1.2.tar.gz"
  sha256 "9c22d98c2debc1e37163b8a703f05278ad5d9c03f1c6b373629d8a072092184a"
  license "GPL-3.0-only"
  head "https://github.com/BelledonneCommunications/bcg729.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc2ddadac500369e8a7f3e61609b9928ba55e7f331cd47e359ea265408b02b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692d7e0f01f4c24c44c1f8e0abee485df6777c78e4e19b09a885447b986878f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74bc5d840c2207667e2f6a73398c8d377a0b5deb3126f6c1012efd7fd3a37cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "73fb05779fc89654981e73a919a057779690b9fbf567803ae1a216d222eaa2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48eb659adf2b64c11983606655e60b965b50ac36f0a500eed040e48def1ec9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e58d6856037731fe82237dda35e40e1d002188f1d1add8083bdf6943c42722"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
