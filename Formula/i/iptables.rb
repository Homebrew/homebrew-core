class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.11.tar.xz"
  sha256 "d87303d55ef8c92bcad4dd3f978b26d272013642b029425775f5bad1009fe7b2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "38c583268c51dbe06d76e48b6146b4caf75bc34726745574e96006e0ec715a64"
    sha256 x86_64_linux: "4de49c1ece1a24f6f72d8290a3d1b4f875a94b9a277640f65faf3258e578a6da"
  end

  depends_on "pkgconf" => :build
  depends_on "libmnl"
  depends_on "libnetfilter_conntrack"
  depends_on "libnfnetlink"
  depends_on "libnftnl"
  depends_on "libpcap"
  depends_on :linux
  depends_on "nftables"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-bpf-compiler",
                          "--enable-devel",
                          "--enable-libipq",
                          "--enable-shared",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Permission denied (you must be root)", shell_output("#{sbin}/iptables-nft --list-rules 2>&1", 4)
  end
end
