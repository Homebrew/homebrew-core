class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/7.0.tar.gz"
  sha256 "fba4607596526d26c15bec3619a9b1ec7c0a482fdd4495cbbf29bb4cb2271521"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  bottle do
    sha256 arm64_golden_gate: "b0c5642a8a921bfadeff0cafeb5047d942306426c4479786f43e342600a3b2c4"
    sha256 arm64_tahoe:       "4ff5636754c94a9c543f147c5c0432a7e50dab67c3f73384f50ab02f17e55160"
    sha256 arm64_sequoia:     "9556e2f2650a8b210f86813d410169be3b5b39da888c293d8003f5831d32f138"
    sha256 arm64_linux:       "f56f2c141176d03b7f7e92dd7249d9393a715e2703b230ea641bbb171e248f2b"
    sha256 x86_64_linux:      "e363ad435cc9735d5f77e149f7498e5d06b3e6a80c016fc7e3f57cec0a9304d3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "valkey" => :test

  depends_on "hiredis"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mariadb-connector-c"
  depends_on "ndpi"
  depends_on "openssl@4"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

  resource "clickhouse-cpp" do
    url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.2.tar.gz"
    sha256 "bac497857759e991fa4e1638bccf936cb36d10ad79273695a570272cc4891428"
  end

  allow_network_access! :test

  def install
    # Remove bundled libraries
    rm_r Dir["third-party/{json-c,rrdtool}*"]

    resource("clickhouse-cpp").stage buildpath/"third-party/clickhouse-cpp"

    args = %W[
      --with-dynamic-ndpi
      --with-ndpi-includes=#{formula_opt_include("ndpi")}/ndpi
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    valkey_port = free_port
    valkey_bin = formula_opt_bin("valkey")
    spawn valkey_bin/"valkey-server", "--port", valkey_port.to_s
    sleep 10

    mkdir testpath/"ntopng"
    spawn bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{valkey_port}"
    sleep 30

    assert_match "list", shell_output("#{valkey_bin}/valkey-cli -p #{valkey_port} TYPE ntopng.trace")
  end
end
