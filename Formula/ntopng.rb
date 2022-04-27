class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/ntop/ntopng/archive/5.2.1.tar.gz"
    sha256 "67404ccd87202864d2c3c44426e60cb59cc2e87d746c704b27e6a63d61ec7644"

    depends_on "ndpi"
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

  # Allow dynamic linking with nDPI
  patch :DATA

  def install
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    end

    system "./autogen.sh"
    system "./configure", *std_configure_args
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

__END__
diff --git a/configure.ac.in b/configure.ac.in
index b32ae1a2d19..9c2ef3eb140 100644
--- a/configure.ac.in
+++ b/configure.ac.in
@@ -234,10 +234,8 @@ if test -d /usr/local/include/ndpi ; then :
 fi

 PKG_CHECK_MODULES([NDPI], [libndpi >= 2.0], [
-   NDPI_INC=`echo $NDPI_CFLAGS | sed -e "s/[ ]*$//"`
-   # Use static libndpi library as building against the dynamic library fails
-   NDPI_LIB="-Wl,-Bstatic $NDPI_LIBS -Wl,-Bdynamic"
-   #NDPI_LIB="$NDPI_LIBS"
+   NDPI_INC="$NDPI_CFLAGS"
+   NDPI_LIB="$NDPI_LIBS"
    NDPI_LIB_DEP=
    ], [
       AC_MSG_CHECKING(for nDPI source)
