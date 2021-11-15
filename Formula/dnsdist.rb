class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.6.1.tar.bz2"
  sha256 "29040a43982ae1ad5b7313f081e26519ab3a58af6bced438311da3a65370a3a5"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7d06f0eba9c36eec1d240c27d38dd00041d75142ea0e41c310036bbcc11f0296"
    sha256 arm64_big_sur:  "869de3f18ef4fd38bf91b7c1c41d38c67e5f83bf58fd891f3360549c3b6523d3"
    sha256 monterey:       "d5d75f9ecba7ded160def73c4d5af60a864a0b717a24126aa04d28c6bbcbbe7d"
    sha256 big_sur:        "977b8f7e4fc0869f95b4cbee33446117eff314802034a2320523d8aefbbaf51e"
    sha256 catalina:       "6701dd21d4fee82fa13705db5f4280bb63d5c7087fee38bdcb05b338fdf6556e"
    sha256 mojave:         "13d58a2f2ff183ae418825f54c454bf960bd9dddc6d357ce5c08025f7d1c23be"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  def install
    # error: unknown type name 'mach_port_t'
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

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
