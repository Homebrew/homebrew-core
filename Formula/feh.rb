class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.9.tar.bz2"
  sha256 "8649962c41d2c7ec4cc3f438eb327638a1820ad5a66df6a9995964601ae6bca0"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4ea744cc172a41beb49619a42cc6a86510459cf5fa0c5768b178da4002f6ee7d"
    sha256 arm64_big_sur:  "b64f18164829cea4ec3c0685ca4adf8966ac899b8e191a623288fe66ca5759fc"
    sha256 monterey:       "0819a99145d8159ab8cde8be50039d17db2f787d63c6c70fcf3e59f9b5b77684"
    sha256 big_sur:        "12b6335728d2ab7dc9d943aeecee6b388e91fea0a044485611b9320da9734be9"
    sha256 catalina:       "4ffced0295e3fa9900d77d232955ab7f933e2bbc524de15b6cab8a656654124c"
    sha256 x86_64_linux:   "4f1684984864ccd2b288ae9a536ffbf5c83ecba3331330f05b1291a081b8170d"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
