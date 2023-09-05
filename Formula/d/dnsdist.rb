class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.0.tar.bz2"
  sha256 "1c0d375c25453d349b88e03ff589aa2603ca8692fc98364c068ead372804704f"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "731eaca23546f77359faf17fa216584df5fc814c943f200d2736da07e3ca89ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c0d84ff02cac1b8d837aff9f7cdcba7f06ebc430923d9a0128cca8934cbf7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6805df831acc1ae2fb833a4409b3ace41b87e2c2622366023888854ea28ba6ef"
    sha256 cellar: :any_skip_relocation, ventura:        "5e8d75a26173aee8f3327e669085baca92ba2efda97f1f03da428c7c2220392a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c28e3d9dbe78cafba90013026220bb7a13e367401b5cfcc5fc53e9c20194e7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8848cdc71dc2ec2fb641e78c11cb1d6878dc77ab9822f7caa8dda8388887bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445c407b023286c3082ff6b661fc73bb8fdd69d4c481c226eed2736feb0d120c"
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
