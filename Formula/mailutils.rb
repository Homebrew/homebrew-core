class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.2.tar.gz"
  sha256 "0b977195fed004eaf1cb680883d5adc099c31bbac5d666c58cde82ac8b9b4e01"

  bottle do
    sha256 "a024ce8993a0cb91d634f85d20e7febe6fcffefb1bf25d41a06965999bcca402" => :sierra
    sha256 "7a8fbf59e72392e54e921551d1467b6374e23f7acb9171764dd1537117430f52" => :el_capitan
    sha256 "51a5d3453cd8b45d49cf776bb6ab2c4f88f34334ce55ff949cfd1ac08aa47306" => :yosemite
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
