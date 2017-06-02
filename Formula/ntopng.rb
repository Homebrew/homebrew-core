class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.0.tar.gz"
    sha256 "3780f1e71bc7aa404f40ea9b805d195943cdb5095d712f41669eae138d388ad5"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "2.0-stable"
    end
  end

  bottle do
    sha256 "60f5fea02d8b2b3a21a692948ff766b46022577bd7b9b06089f47394d6c757dd" => :sierra
    sha256 "1fc7e9e953d8f56e76be90b02b3d45e91cd2a9bb398a6635a992c733574e6058" => :el_capitan
    sha256 "22821f8c3b10ebab568755a86349ed0a65a28ea04f262df94771e71b8f423502" => :yosemite
    sha256 "156d8545cc8632d4ecb92d2cea86f784da0150f0cd9e0a567985ba9785b1ae1f" => :mavericks
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  option "with-mariadb", "Build with mariadb support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "luajit"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

  def install
    # Prevent "make install" failure "cp: the -H, -L, and -P options may not be
    # specified with the -r option"
    # Reported 2 Jun 2017 https://github.com/ntop/ntopng/issues/1285
    inreplace "Makefile.in", "cp -Lr", "cp -LR"

    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-V"
  end
end
