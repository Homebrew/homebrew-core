class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.2.tar.gz"
  sha256 "0b977195fed004eaf1cb680883d5adc099c31bbac5d666c58cde82ac8b9b4e01"

  bottle do
    sha256 "5fffeefa72bf0af1f6b7d216e363a6723e7651eb0d409450c94f7baed9f882b0" => :sierra
    sha256 "a57eb344e881e4c9938ea47b117bb2e59f6d1434e523c6e5e3a52262173c9836" => :el_capitan
    sha256 "d789e0d108ced0095019cbaeb1d8b2ab1e2e667387f8b946a5f2d425e084be33" => :yosemite
  end

  depends_on "libtool" => :run
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
