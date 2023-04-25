class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.0.tar.bz2"
  sha256 "1c0d375c25453d349b88e03ff589aa2603ca8692fc98364c068ead372804704f"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da5534e94d3cfe5b8a277e4231efbf7933322594d9c28adb207aeb1bef3b6272"
    sha256 cellar: :any,                 arm64_monterey: "fba41b16ddb6b29dd48a7186bccf4d483a2de52789c61570cb85a38eaaf0a089"
    sha256 cellar: :any,                 arm64_big_sur:  "4b95617efafc5c0f88ef090fbabb122f241df603285a6659ef28ff2996beef2e"
    sha256 cellar: :any,                 ventura:        "10620accac10c0de624d7030a4ec395b68c65401acc799412d49d09ea1e39ee7"
    sha256 cellar: :any,                 monterey:       "f73e5fbc6d042dd180f260aaef1a4b8bd35d40c2748b0fa0caec1ce95fb300eb"
    sha256 cellar: :any,                 big_sur:        "f704b4dec54e6eb977662f2ffc52943a0a6b21cb3376670c0c0603d62804ce57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba0f67c075aae24bc68364769a4f2b434c3fc75f4b467f3b8c1d4ed67eb79f1"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
