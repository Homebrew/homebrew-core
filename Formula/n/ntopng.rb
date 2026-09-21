class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/6.6.tar.gz"
  sha256 "2e97fbd26c2f9ac526214e2a2e22ecb218e38f5e99a688c25ae6cedbbc3a892c"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  bottle do
    sha256 arm64_golden_gate: "8a46c6e4f5082c8038d667cf85588e329e35b53cc072f372d75d5569c83fb3b0"
    sha256 arm64_tahoe:       "31dca890e874b633ddcdedd66f9caf8f33e3b0537c132596250ed5c826e48203"
    sha256 arm64_sequoia:     "17d29b067e7c5f58e94de37b2c757b78cd875f3872cd589632e7fb2928720733"
    sha256 arm64_sonoma:      "0388c71551652c2ad43c79eff4573a68446f3e8ee949403c6aa7c10b9464efad"
    sha256 arm64_linux:       "7a81b7b962d1fd6288dacde2e4142f7baf4e15be67b3c1e1f1e85ac01efdb814"
    sha256 x86_64_linux:      "80d93071170ccba000fef3c323a78ef92cf341cd43fc14f4a8fc8afcb5671dbd"
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

  # Backport nDPI 6.0 compatibility from the upstream 6.6-stable branch.
  patch do
    url "https://github.com/ntop/ntopng/commit/896091d7f2ada1a173299fe71b785ce14cbb9b0c.patch?full_index=1"
    sha256 "97972994d02777d68c6a99975e8fc71ec89a49be9f10c840b4409f27d8b57f7b"
  end

  # Keep the flow-risk table in sync with nDPI 6.0.
  patch do
    url "https://github.com/ntop/ntopng/commit/ad4d75408064e24c728b6ae659e032daa2979695.patch?full_index=1"
    sha256 "56b906b1dafdd28bbae689afdb4a077ae467398497adbc41f3cc05d8d6e07156"
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
    valkey_bin = formula_opt_bin("valkey")
    spawn valkey_bin/"valkey-server", "--port", valkey_port.to_s
    sleep 10

    mkdir testpath/"ntopng"
    spawn bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{valkey_port}"
    sleep 30

    assert_match "list", shell_output("#{valkey_bin}/valkey-cli -p #{valkey_port} TYPE ntopng.trace")
  end
end
