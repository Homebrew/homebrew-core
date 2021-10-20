class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.2.0.tar.gz"
  sha256 "2303e6f99b1fde8ee3c3ab28a4de2da6ddd225c953693e845d6b2d8388221fb3"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d07c98078f134dd3d85eac5c0a12f545aece45d1db802cd4166f682d45d39ac2"
    sha256 cellar: :any, big_sur:       "f94b42de1a75d06f03c5b3305fc87f5dafb31a5ffaa434eaa08b37c565393e4e"
    sha256 cellar: :any, catalina:      "30da2a4411ea4ec28d206f74d45914c1ce3367174a0405eec7c068fbdce42c26"
    sha256 cellar: :any, mojave:        "de010f567513cb4a87c0586a02db30e66c54730f81ee92257e95a91ece269156"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}/pam/pam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in /etc/pam.d.

      For further installation instructions, please visit
      https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system "#{bin}/pamu2fcfg", "--version"
  end
end
