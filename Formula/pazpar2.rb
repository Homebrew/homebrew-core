class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.6.tar.gz"
  sha256 "a03b6fe430d2d83b916975aa525178893156cb1fa478e86160acc2088a35d036"
  revision 1

  bottle do
    cellar :any
    sha256 "e985cd0262786850462c0901bec6b8b12475cd123f627a1fc5b091811c31fa24" => :sierra
    sha256 "e2018db8519464882d01ca913b051c659accb365d37d3d0a15531d613f6357a8" => :el_capitan
    sha256 "7ddc95c295c5b58d91397254d65a05653949c5af4c2707c08ae29d8851e9d8aa" => :yosemite
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/pazpar2", "-V"
  end
end
