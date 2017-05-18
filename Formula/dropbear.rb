class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2017.75.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2017.75.tar.bz2"
  sha256 "6cbc1dcb1c9709d226dff669e5604172a18cf5dbf9a201474d5618ae4465098c"

  bottle do
    cellar :any_skip_relocation
    sha256 "06ec7a95e2d60c0898cf596a2442dd524744ba4bb309469db969da13801ec11f" => :sierra
    sha256 "8710753a40480bd472b90a75375cfb0dc2fc8f40e2f454bbb85989256685f5a1" => :el_capitan
    sha256 "d10e0571037b42d5ea665c63f720603b5b0e0aedec39e97c1727b9ea261e34e2" => :yosemite
    sha256 "5d08ad835636ba85ccc5264573dcc5c2c2fb5f43a11522cbbb78600e7d63100f" => :mavericks
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert testfile.exist?
  end
end
