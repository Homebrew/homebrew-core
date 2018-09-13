class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.6.tar.gz"
    sha256 "43a90940936e6c7c39cb35c6e87ff4f1cd80b7620941686341fe1713421949cc"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.4.tar.gz"
      sha256 "5243e16b1c4a2728e9487466b2b496d8ffef18a44ff7ee6dfdc21e72008c6d29"
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
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq" => :build
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "mysql-client"
  depends_on "redis"
  depends_on "rrdtool"

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
