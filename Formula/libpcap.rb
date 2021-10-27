class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.1.tar.gz"
  sha256 "ed285f4accaf05344f90975757b3dbfe772ba41d1c401c2648b7fa45b711bdd4"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "806a586f73f832dcc33b9c6019c8f8fd5e38c229abe5a2e84335bf6250e785bb"
    sha256 cellar: :any,                 arm64_big_sur:  "56f83e298a7906e44b44ac6d0c99f9a02d0be2ea4726089171a045543368ea9c"
    sha256 cellar: :any,                 monterey:       "3a77261badf57e93273aa3190348d34a27231e728cb0cd4d4c501e874bd7b2c6"
    sha256 cellar: :any,                 big_sur:        "0aee8b23fc3ede63cbd2cde3bbbaade84ffd6f2ac90315f9738fb872236a8c2f"
    sha256 cellar: :any,                 catalina:       "8d57e7519f14cfec3a1104237e52b56e838faa33b07cdbac05572533e5ae7e07"
    sha256 cellar: :any,                 mojave:         "a31646c901c2fdd953e648e5c5715ec2cdcf49c9e661725a8e56d9f6c38890dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f11278ffe1e2353d3acccbc3bf23999d08d9f14deaa86931adff289aed031caa"
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
