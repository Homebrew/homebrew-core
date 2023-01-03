class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.2.tar.gz"
  sha256 "db6d79d4ad03b8b15fb16c42447d093ad3520c0ec0ae3d331104dcfb1ce77560"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95fe36918489e63ba5f6b9678985d4bbefbb52ce1d1e48111c4a448d0d630986"
    sha256 cellar: :any,                 arm64_monterey: "ac0f03c0acc1f9bf796e549fb112c5709e3a92a55b94f07b665c591fdd62328d"
    sha256 cellar: :any,                 arm64_big_sur:  "bd652602b5bdba4b332ff3dd486673195c5a1e5d1921dc5d514d913cf641cf7a"
    sha256 cellar: :any,                 ventura:        "b635f35738527e6b914702a3566f834ffa29d28912acd3cb0552e6909fc8df57"
    sha256 cellar: :any,                 monterey:       "4af0060aa27df804342d6efc675dc7e2b9bbf299415de1c5a59d15053aa65c15"
    sha256 cellar: :any,                 big_sur:        "18161bbf25a8256ae0b03f37953aa74d394dec2371667db09311a993e68be305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e92db17316e30edd522bb82923056516479ba8153ec98cd6fb9c6b995653ca"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    assert_match "lpcap", shell_output("#{bin}/pcap-config --libs")
  end
end
