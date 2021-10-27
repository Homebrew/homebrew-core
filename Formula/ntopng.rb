class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/5.0.tar.gz"
    sha256 "e540eb37c3b803e93a0648a6b7d838823477224f834540106b3339ec6eab2947"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git",
        revision: "46ebd7128fd38f3eac5289ba281f3f25bad1d899"
    end
  end

  bottle do
    sha256 big_sur:      "1f0fc365c6ce9765f3457e3fd610494bb135db0e4970365de6dee02ee6a82ef6"
    sha256 catalina:     "3f66b1d9932cb383bee198896deec6ebad14af61d84e211a511546505986fe73"
    sha256 mojave:       "72411fa027ffdbf74e99c030c28f1816df70b3c640cce0465419bf821f0df379"
    sha256 x86_64_linux: "ceced6dd2af35eabe2d0c0d3f90fd201597f3f6abd5ef483b8cb1da3b3fed7c9"
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "lua" => :build
  depends_on "pkg-config" => :build
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "mysql-client"
  depends_on "redis"
  depends_on "rrdtool"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    redis_port = free_port
    redis_bin = Formula["redis"].bin
    fork do
      exec redis_bin/"redis-server", "--port", redis_port.to_s
    end
    sleep 3

    mkdir testpath/"ntopng"
    fork do
      exec bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{redis_port}"
    end
    sleep 15

    assert_match "list", shell_output("#{redis_bin}/redis-cli -p #{redis_port} TYPE ntopng.trace")
  end
end
