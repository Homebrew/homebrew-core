class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  revision 3

  stable do
    url "https://github.com/ntop/ntopng/archive/3.2.tar.gz"
    sha256 "3d7f7934d983623a586132d2602f25b630614f1d3ae73c56d6290deed1af19ee"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
      sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
    end
  end

  bottle do
    sha256 "e7315a06207aebca9826d516e390142e039885f9630dd53daa0032ea5cecaf65" => :high_sierra
    sha256 "9c0f54169acb2a4ddd67b201b83a946009d14d1e77590c648be4bb28fd26d099" => :sierra
    sha256 "ec24a5e1ae49b79a747c5fe61e8e1bcd8f5d427ac1ca69b564cc8cce441859e7" => :el_capitan
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
  depends_on "mysql-client"

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
