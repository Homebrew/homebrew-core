class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/ntop/ntopng/archive/5.6.tar.gz"
    sha256 "0877b6492871509611d3201df835a5e10ec75cc87cb85f5aa667988587c90d20"

    depends_on "ndpi"
  end

  bottle do
    sha256 arm64_monterey: "3e1f0641e68312b9df99d6352a30463b9c7e3ae77af87d7108d7f53ef1a1e915"
    sha256 arm64_big_sur:  "f15ee478e6890c6ff3c223b3687712e95715957273c81f00012e42166c56f3ab"
    sha256 monterey:       "f23a75bc3a049ffe88a63eac33c69679676f21a5794cf981b48727ea657d3b83"
    sha256 big_sur:        "f113c35addc3839fd3fe1fd20c2b3a94be4082e9969638d86cdf4c945ddcea1b"
    sha256 x86_64_linux:   "a8aaa3edac2b6c93e95bc660b850f1cda8ce0033112128823b086f3ac289b378"
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

  fails_with gcc: "5"

  def install
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    end

    system "./autogen.sh"
    system "./configure", "--with-ndpi-static-lib=#{Formula["ndpi"].lib}", *std_configure_args
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
