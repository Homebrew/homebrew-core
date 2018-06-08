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
    sha256 "adb72c85bd04a9707a85d7c06282cb7c92641ed0775bcb686987031b8a5e21dc" => :high_sierra
    sha256 "6647cdce6eecd2163326cc73f79b40390525f799c147d472a789db4a089d4f56" => :sierra
    sha256 "0eef0fb0ef2c1d9c34761b324097ea0a938ae41a2cc0e5fdf5f4019a455884ee" => :el_capitan
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
