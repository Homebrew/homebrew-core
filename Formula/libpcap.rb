class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.0.tar.gz"
  sha256 "8d12b42623eeefee872f123bd0dc85d535b00df4d42e865f993c40f7bfc92b1e"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "19f6daea5e631f363f67d0d9a2c632367d839c400f7754f1e1f1812f0d926890" => :big_sur
    sha256 "ba095e539d7f5680521610f0d78c6000322f71ad6e922518bd32320ab2332f92" => :arm64_big_sur
    sha256 "82aad50c8453472a11b848eeb8214c97fab2e78343bac0ba08c33af83cc82e63" => :catalina
    sha256 "d0f2461b7f0155e32d858eccd6c227064991eb2d44a023eb8759926af2481652" => :mojave
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
    assert_match /lpcap/, shell_output("#{bin}/pcap-config --libs")
  end
end
