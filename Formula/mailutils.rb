class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.3.tar.gz"
  sha256 "06f4f5649ae81735765121236443bbefcbcc4ea53c10768380d7247757ff9713"

  bottle do
    sha256 "e33264c4196d8401b5dc91df196392e8bbebccafcfa718e2b38209533dfb67a6" => :high_sierra
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
