class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/3.2.tar.gz"
    sha256 "3d7f7934d983623a586132d2602f25b630614f1d3ae73c56d6290deed1af19ee"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
      sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
    end
  end

  bottle do
    sha256 "b081d1c51e866004ca67152de76ff3a6fd29ebad435eaaf8b4e7bf233b313b4e" => :high_sierra
    sha256 "9806a98d28853c7c8679c90bb2b9d40f62b4c1c3f4132d8aa36a6dc78d206796" => :sierra
    sha256 "dc4876dbffa7871f30b899bacad272f721bcedc51019713691790825f867d1f9" => :el_capitan
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql"

  def install
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
