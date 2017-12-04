class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.3.1/libmaxminddb-1.3.1.tar.gz"
  sha256 "5d55a1327dcca5c819a6a7a260afc0d1bd9626824e40073c7564fdb8d91ca186"

  bottle do
    cellar :any
    sha256 "14c83967e871e653719c8d506e604fddb5a4e8623fd05289dfd72aaa4583aa18" => :high_sierra
    sha256 "385cf24a5ca3c94b696fa73ecc31da3c89fa64e34280db1cbc8c97074dd94e04" => :sierra
    sha256 "12d682847889621eaba4d6ed06a3497e37fc81aa7867c8250f572c216ea32b03" => :el_capitan
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoipupdate" => :optional

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
