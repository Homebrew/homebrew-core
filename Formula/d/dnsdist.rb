class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.0.tar.bz2"
  sha256 "16bab15cad9245571806398a8e4a5dc32a92b6bb60e617c12fe958c945889c7c"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ac0bf3c264089a271a8bc10e71115d903946d760a3a403d583f43925ca57e41"
    sha256 cellar: :any,                 arm64_ventura:  "cf26adc7ae045362f22be3138ecc0ecc81dcce39a81ffd72e962d9fc72ab0678"
    sha256 cellar: :any,                 arm64_monterey: "852fc6596567b717418745eee66a4527eb1331ad5156da2e781aef3032d83ae9"
    sha256 cellar: :any,                 sonoma:         "d2de41df5a515f10a28ca1eb2e21d3459a3dbaac9b10baed3ca55ccf8f4c8dd5"
    sha256 cellar: :any,                 ventura:        "7d4079b99e919ffaad45e515c8158c50a4fa2be82c5e9f58ee8401f97a674df5"
    sha256 cellar: :any,                 monterey:       "638cc0ad30087b5ece03d1827cced22343e71e599aff801d3ea80cc1695731b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c63de25852a3ce5876f638afd504966ae9218e25f76f2e15a4241cc26a69a0"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
