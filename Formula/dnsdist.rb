class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.0.tar.bz2"
  sha256 "1c0d375c25453d349b88e03ff589aa2603ca8692fc98364c068ead372804704f"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81b9b4b5fc783c74ddb725b0ef39ae4a9aad314ebc049c60a4177393e252d721"
    sha256 cellar: :any,                 arm64_monterey: "6896440134f4ddc23117147f3f36b5a2c0a83d7017b3e95831a0871b8a20757f"
    sha256 cellar: :any,                 arm64_big_sur:  "ba08dc7ba1b1968f8c547a0c8853e3df4bf0cc20ba7d92c96c7af0c6bdb2fa9f"
    sha256 cellar: :any,                 ventura:        "698ac4d56792a03a0dbbb9fe32d7150fbaa1f2a5d6a6728980b86d9ec048e15f"
    sha256 cellar: :any,                 monterey:       "5cebae77ea0d8df9996374b67689744103f512c0b8f409d125f6e830eebcd49f"
    sha256 cellar: :any,                 big_sur:        "d5c3c4cc8d2561a848b374743209198f488b80f00216d1f10576086ec0ed5658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc304272dc9992068122dd5323010be7e078f3ef2c1f1d8ebdd64966f9510b22"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
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
