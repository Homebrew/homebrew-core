class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.6.tar.gz"
  sha256 "a03b6fe430d2d83b916975aa525178893156cb1fa478e86160acc2088a35d036"

  bottle do
    cellar :any
    sha256 "488901bec183bb366228050e821136722ed4f1a051ca375d17657a6ec4dfaa94" => :sierra
    sha256 "ef8cda0a9182553453cc0a1f17c8ed279044925d52182b5f61f95b4c15c25231" => :el_capitan
    sha256 "bf4f63859e37fc44570da9d0de18d0a13bb9878e105d0d4a4e24bb7a8c8b979f" => :yosemite
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
