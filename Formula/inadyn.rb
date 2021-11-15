class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.8.1/inadyn-2.8.1.tar.xz"
  sha256 "1185a9fb165bfc5f5b5f66f0dd8a695c9bd78d4b20cd162273eeea77f2d2e685"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 arm64_monterey: "51570d800785bf2c97531b5d80aa4eb07ed51e0049beb28f5efde4b23923983c"
    sha256 arm64_big_sur:  "3459e2119123af5cceab755c044952c6399e80bf0efb67ae2c5a5c268b618341"
    sha256 monterey:       "fe3cfb83cfbf077c5af30175643f0a89500402637e4a288ce27f96fa35dd1e06"
    sha256 big_sur:        "5046bd4f55ab963fdfa8bb8edd46454b2bf5b8e0e5f7ae8b1ba6f6d4b81251ee"
    sha256 catalina:       "e0a601e59fecb91b7932eabfaf7b276a45cadb2233ca2fbde1e71e17240a96a4"
    sha256 mojave:         "5f26612509b04128a4cc7d73c4a47520a7c72e3575de255f9b579c6a94255f0b"
    sha256 x86_64_linux:   "56cc59f1fa37c788df4d98bfe8841debe79207d018122eedbcb0cc7954d8e786"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
