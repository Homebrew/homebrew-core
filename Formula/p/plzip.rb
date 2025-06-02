class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  sha256 "50d71aad6fa154ad8c824279e86eade4bcf3bb4932d757d8f281ac09cfadae30"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e3cd08078f11ba7ceed4c93c1e0fdc788decf11d2d4d0855c52e803e3ade99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69f87f246b7b84977dd3690867ec9db32e05610a415d2fbe9a6be69ff4b63da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bedd1525dd0a949b298fc354e05ce35f3c08bc9b8edb9778ccc9186e838d0624"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6fa3ffd911737b50041ffbede6cf6d39cf54608be10093c755b28dae1d7121"
    sha256 cellar: :any_skip_relocation, ventura:       "21bed828b80d4dd6b40a0e75b236996f334ab8b76f92155192b3ea984410df6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d600a14782d931755a8998785a5b284296bbee80a13f76ebfadbbf69c0cf9ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35aab3bc41f9112cd01216df0902af5b126cdbe340c91396acdbf006506fe3d"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
