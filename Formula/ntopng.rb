class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"
  revision 2

  stable do
    url "https://github.com/ntop/ntopng/archive/5.0.tar.gz"
    sha256 "e540eb37c3b803e93a0648a6b7d838823477224f834540106b3339ec6eab2947"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git",
        revision: "46ebd7128fd38f3eac5289ba281f3f25bad1d899"
    end
  end

  bottle do
    sha256 arm64_monterey: "68bc573dc0f255b53e9ace0ff6053964822964ab83dc8ea2aaf872a80b0d6fdc"
    sha256 arm64_big_sur:  "e0d1448d1c891f910c2030a8acec578f6b4d3eae74626688584ab472a5884445"
    sha256 monterey:       "8b5fc5a64bbb1f6561bfa691a7d4d68e71d2df69ecb9aed7d14dc5d2c7a6da62"
    sha256 big_sur:        "600e95026b9fe50bf256a1188f3c5488dd8eb2c478aa041a9698796cf2a0ab45"
    sha256 catalina:       "34241759200243e7ba06a85aff12a02ebe13167fafcfd35e3ab74d202075216d"
    sha256 x86_64_linux:   "6807697535223ab5df55cb90700f9a7811f9bdb1aa72fa8ef6405be03a279b2e"
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
