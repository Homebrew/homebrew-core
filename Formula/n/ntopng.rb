class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/6.6.tar.gz"
  sha256 "2e97fbd26c2f9ac526214e2a2e22ecb218e38f5e99a688c25ae6cedbbc3a892c"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  bottle do
    sha256 arm64_tahoe:   "678240618abb8e6af0bc0c4bf8b6a120b1bb986ca4c88d842ffb97042c6f8a68"
    sha256 arm64_sequoia: "c1256937da21c4f16c39faefecd81f0511cfc61be90433ae1e91b565d8b9272c"
    sha256 arm64_sonoma:  "bea740dd573b3e4d9c8b0778a3538f6c8620aafbb723675c5e9b5f9be67e5e9c"
    sha256 sonoma:        "2c272f207cc31ad8030b1afdf3587ccfded7be50c511825b8fb49007e9fb03f3"
    sha256 arm64_linux:   "279a28665086ba1f41861b94013e6576d3f1e6481d4afa66fbc0cff422b86033"
    sha256 x86_64_linux:  "8eb7bc1027a51bdc9444e52a971064029710bb3f0cc601f7454638d18833cf26"
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
      --with-ndpi-includes=#{formula_opt_include("ndpi")}/ndpi
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
