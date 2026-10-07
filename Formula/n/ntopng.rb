class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/7.0.tar.gz"
  sha256 "fba4607596526d26c15bec3619a9b1ec7c0a482fdd4495cbbf29bb4cb2271521"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  bottle do
    sha256 arm64_golden_gate: "d758b7ee36aaac969bc288990ceb30502c6df86f7d575f6d1743182faac36e23"
    sha256 arm64_tahoe:       "f89e33d74907438809b6a51d0fd1d370308d25cc6e5ff305c50607fda0e909ef"
    sha256 arm64_sequoia:     "4eec16ee52b70da1ace7fb0b7997546b79ebf199f6295b755bea1c320e7217ca"
    sha256 arm64_linux:       "efb374b909af2be849dd1e94db7e5a5380301b4f9294618a8f033716e690ae2d"
    sha256 x86_64_linux:      "588ee8d0ff27dfac936477af1d6a0a488789f7127810787ef467c507afba827c"
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
