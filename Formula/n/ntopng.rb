class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/6.6.tar.gz"
  sha256 "2e97fbd26c2f9ac526214e2a2e22ecb218e38f5e99a688c25ae6cedbbc3a892c"
  license "GPL-3.0-only"
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "228fe15cfa6146f9c51b05d0ae6b7545c6a5f2b5239d989858b40550121b0e20"
    sha256 arm64_sequoia: "95bd7ecf2920b30bdd7967c334820dd8efa0f4e077488f6110e0ff72c1b6bb21"
    sha256 arm64_sonoma:  "559da0d0cfc7f0e1e0068bda0fa3688e5862eb2af13ed074f938d1b4c3c27abd"
    sha256 sonoma:        "1e2ae802d297666a7af70c177fd1aabdfc1e2ee5ce36d2454a2426c2275a1ce6"
    sha256 arm64_linux:   "47de4bd1eb4ed5f348330aedb1cef65517b5fa3edcf5afead0ddc75640368580"
    sha256 x86_64_linux:  "566aba2570620468609f295bfe3ac606aff9710f34e7f5283b9e6d6fc7c9ef1a"
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
  depends_on "openssl@3"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
  end

  resource "clickhouse-cpp" do
    url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.0.tar.gz"
    sha256 "f694395ab49e7c2380297710761a40718278cefd86f4f692d3f8ce4293e1335f"
  end

  def install
    # Remove bundled libraries
    rm_r Dir["third-party/{json-c,rrdtool}*"]

    resource("clickhouse-cpp").stage buildpath/"third-party/clickhouse-cpp"

    args = %W[
      --with-dynamic-ndpi
      --with-ndpi-includes=#{Formula["ndpi"].opt_include}/ndpi
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    valkey_port = free_port
    valkey_bin = Formula["valkey"].bin
    spawn valkey_bin/"valkey-server", "--port", valkey_port.to_s
    sleep 10

    mkdir testpath/"ntopng"
    spawn bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{valkey_port}"
    sleep 30

    assert_match "list", shell_output("#{valkey_bin}/valkey-cli -p #{valkey_port} TYPE ntopng.trace")
  end
end
