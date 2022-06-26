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
    sha256 arm64_monterey: "65efdae761d1ae845a48d304daf459af893cfeedc004ca598db3c39650c20fdf"
    sha256 arm64_big_sur:  "ad20989ce5163ffe940e954c6eaff38cabf2e5d0922c4aba4a7a86e4e592db30"
    sha256 monterey:       "a7523c2a2d83dc057f360a9656d1475d0cc73d3d5534beabcdd2307126c0a0e6"
    sha256 big_sur:        "bfbbc638a791fe1e2ab951396243faae914a8249441c900b1d8db877fae376bb"
    sha256 catalina:       "dfa4fa4fdaea595da3d102f08d5522737c931aa6a33b136480f7233bec934cbd"
    sha256 x86_64_linux:   "420bdc0167bc229a009b030100ec612fdc57b19ca09de0896e70278081668a55"
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
