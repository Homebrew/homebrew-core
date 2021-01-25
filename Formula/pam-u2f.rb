class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.1.0.tar.gz"
  sha256 "0dc3bf96ebb69c6e398b5f8991493b37a8ce1af792948af71e694f695d5edc05"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "f839f2092a454245e7d803c2173963be8eb084574707205277121d9047ec870b" => :big_sur
    sha256 "506a178827a1b2b381815ba1a8ae693b0fcb68a6eb452044d2bd4adc1690154d" => :arm64_big_sur
    sha256 "cdc5fa2db8788501c8fe8c9142bc0686d5ad2b1e7c3cfb4dc35d95788cb58485" => :catalina
    sha256 "30cc76b0b4d582c076c9fed1ed880442b67b987973b57fd52e26a93356e5eef6" => :mojave
    sha256 "bfd1309cb6deff47c4473b0af86f645b0ee29eca712ebce67d031b770f742a24" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"
  depends_on "libu2f-host"
  depends_on "libu2f-server"

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
