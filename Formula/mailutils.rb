class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.8.tar.gz"
  sha256 "ffe91d5f54f58e78ec65a566475d6890ec23f634ce970c6d28ceb60d2578b71f"

  bottle do
    sha256 "f769b017c69909513663983b0b18b782e2f523a57e27f7e856b831f433305449" => :catalina
    sha256 "be6e0c786604ac1cd9ad074ab3d957fce8aa875b04f171bf01173da5669b03f6" => :mojave
    sha256 "b0a45ec764015639c065186fe1074300035f0a3d2458162048899222fbf32652" => :high_sierra
    sha256 "8555d63a0d240ffd3948076f266aa3b88c2197e2becab0f463918facb8501f2f" => :sierra
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
