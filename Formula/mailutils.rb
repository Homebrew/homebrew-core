class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.7.tar.gz"
  sha256 "e95920d23b5ded11479d2aded795e7f8f94e02c88e05198e9093f23b45eb04fa"

  bottle do
    sha256 "d1e191fc899b56957fe5b81ead95466cb8332025226ca8c98e23171f45eb6cb0" => :mojave
    sha256 "e5971d7a4667cf9780fa723e92519524c3c60a2210db74ca57b91b8d94486978" => :high_sierra
    sha256 "79b96a7b7d055a1ff58735fcba664e35b5ca38d50d1ddb78685c8d1d002a8278" => :sierra
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
