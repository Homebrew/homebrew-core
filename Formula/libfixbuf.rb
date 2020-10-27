class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.0.tar.gz"
  sha256 "bf20f9f7986a525ea6cc648d32f4ba30bfeb2a83f8c830bc39c48dfa7a415175"

  livecheck do
    url "https://tools.netsa.cert.org/fixbuf/download.html"
    regex(%r{releases/libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "39eac22cafeaa515259fe5b8ddd635b98c69ca42699107bd05e5560d285f6724" => :catalina
    sha256 "5c63110b498601708f2669fa1c5c734a4d8d67abbdfdfd5056255c746ef6e6ee" => :mojave
    sha256 "d76d8050c0355326777460e738008b3820b39c53ec38ee759c0c8ddacf0c090e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
