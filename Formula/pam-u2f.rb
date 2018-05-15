class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.7.tar.gz"
  sha256 "034aad8e29b159443dd6c1b7740006addc83d0659304fc4b0b4fb592f768e7cf"
  head "https://github.com/Yubico/pam-u2f.git"

  bottle do
    cellar :any
    sha256 "afca2620432c6409c74c05964351b689d0ef531bf3f92c03ac4e550fc54841fb" => :high_sierra
    sha256 "5b8df58d53948ff20dd7f6284a6d830f0e4087e573ba210adc526a3b9273ca1c" => :sierra
    sha256 "ddfb23e7cddf6b47e78c889a8041690aab670d7724ebfcc27ca60018d780d127" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "asciidoc" => :build
  depends_on "libu2f-host"
  depends_on "libu2f-server"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats; <<~EOS
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
