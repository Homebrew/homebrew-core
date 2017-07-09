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
    sha256 "accef6e537eca111021c9eefb3b142b80ddeec313b0c3f8924aaf785a9f839ed" => :sierra
    sha256 "ec35e60a6fd33a1ed3631b2bc99845923388ba8f5ee5d61d06b342fe78547061" => :el_capitan
    sha256 "6b0c53620382b61d40c1553fcfe15f0d8da5cefc8f3687627540f81ddb827edb" => :yosemite
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
    if build.with? "mariadb"
      inreplace "configure.seed", "mariadb_config", "mysql_config"
    end

    # Prevent "make install" failure "cp: the -H, -L, and -P options may not be
    # specified with the -r option"
    # Reported 2 Jun 2017 https://github.com/ntop/ntopng/issues/1285
    inreplace "Makefile.in", "cp -Lr", "cp -LR"

    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath / "nDPI").install Dir["*"]
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
