class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.7.tar.gz"
  sha256 "e95920d23b5ded11479d2aded795e7f8f94e02c88e05198e9093f23b45eb04fa"

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

  # Patch to fix build error:
  #
  #   duplicate symbol _status in:
  #       .libs/dotmail.o
  #       .libs/message.o
  #   ld: 2 duplicate symbols for architecture x86_64
  #
  # Patch has been accepted upstream, remove on next release
  patch do
    url "https://git.savannah.gnu.org/cgit/mailutils.git/patch/?id=b696daa86b51a38841e4c39bce0a46eaac2f1db4"
    sha256 "919c89d05ae88c33ff715b14fd47733960eb8f633835f3ca6f1867995a51e5a5"
  end

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
