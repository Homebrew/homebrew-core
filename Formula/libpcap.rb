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
    sha256 cellar: :any, arm64_big_sur: "ba095e539d7f5680521610f0d78c6000322f71ad6e922518bd32320ab2332f92"
    sha256 cellar: :any, big_sur:       "19f6daea5e631f363f67d0d9a2c632367d839c400f7754f1e1f1812f0d926890"
    sha256 cellar: :any, catalina:      "82aad50c8453472a11b848eeb8214c97fab2e78343bac0ba08c33af83cc82e63"
    sha256 cellar: :any, mojave:        "d0f2461b7f0155e32d858eccd6c227064991eb2d44a023eb8759926af2481652"
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
