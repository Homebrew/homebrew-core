class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.2.tar.bz2"
  sha256 "524bd2bb05aa2e05982a971ae8510f2812303ab4486a3861b62212d06b1127cd"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "217340674a363376daf3661f32c2228e6a47fdc18c56a255d80879011ba792ed"
    sha256 arm64_big_sur:  "d5754f3a410aca4e97f47838aea285328371d64e5ead938f46ca5775956e9192"
    sha256 monterey:       "ae1c1eab2e439280c15d986724170e308fbe675412cb43a7f8350028376d0ee9"
    sha256 big_sur:        "59dec63be07da8392bd6f469e8e45e2385862cbe3b00c652731ac3dcdbcd99c1"
    sha256 catalina:       "e5fb9b7356c8e2453ad5fd6a3ac9da6315f99b400214b6d93b664abe2520d455"
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
