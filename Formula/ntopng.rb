class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.2.tar.gz"
    sha256 "3d7f7934d983623a586132d2602f25b630614f1d3ae73c56d6290deed1af19ee"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
      sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
    end
  end

  bottle do
    sha256 "e4f7e647e5c37d3d936f8d18a3ebb620ed80b806c60275a09f5e3815e85db873" => :high_sierra
    sha256 "5103e823d0792492aeaa3ab36d83f71fa2697d526bd92c963b2882b809ce6687" => :sierra
    sha256 "dd1b65f7942118b0fa313b8560ce98ad15b3de91417ad596872b82b48161ee42" => :el_capitan
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
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

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
