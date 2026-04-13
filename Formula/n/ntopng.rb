class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/6.6.tar.gz"
  sha256 "2e97fbd26c2f9ac526214e2a2e22ecb218e38f5e99a688c25ae6cedbbc3a892c"
  license "GPL-3.0-only"
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ad21a48529fb2d9342fae2ccd7917ea2ec48db11f39f1502b295a08d0014ab0c"
    sha256 arm64_sequoia: "8aca05d9e9e80b09d69c3840cbfca39c10ce988433b7a3855df7d6479c3598e0"
    sha256 arm64_sonoma:  "6af02e8b862c98dcd92ecd8447f4b1b8a3ff31c4a7be6fa8c958e85b8c2402ad"
    sha256 sonoma:        "70de138eb5a6b07cc28c555f784011e9c423cb61b0758ee24440f68debb8af8f"
    sha256 arm64_linux:   "febfe7fde846b678bcfd8f2aefeea4d807315d4a490cb9e8daee9ae34f6c7792"
    sha256 x86_64_linux:  "94c2efe3b6277a3f4942865476a329ae413a58c73047a9faed559344a9103654"
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

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
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
