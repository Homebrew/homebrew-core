class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.3.tar.bz2"
  sha256 "7eaf6fac2f26565c5d8658d42a213799e05f4d3bc68e7c716e7174df41315886"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5e1aa8fdc0f0479ca3995686829eaa8fa945994074810739b344229b23a156d8"
    sha256 cellar: :any,                 arm64_big_sur:  "47e75924e7a7330b88dea7e109021bb9f30ac47122e9aee527f8aca8caf79ad1"
    sha256 cellar: :any,                 monterey:       "a39684a3ae9da0e8af2d76759178b38432af47c51426251c0843df280e41d93a"
    sha256 cellar: :any,                 big_sur:        "bf3dedd199b0928575036c3ec7546bbbaf2453c99001115f7125e8a406ddae14"
    sha256 cellar: :any,                 catalina:       "a18acb0a959aa7ceac7548a7cd0f73262bf9f07aff8b6c17d75077a0d5d5b170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c09500bb7efd63bc04dcea91e567bbf2aee9e80185b50b00c95f5155081cfe0"
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

  on_linux do
    depends_on "linux-headers@5.16" => :build
  end

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
