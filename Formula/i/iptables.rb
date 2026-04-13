class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.13.tar.xz"
  sha256 "1afcd33da9e8f913ace6a2126788162e207e26f5d5e29c6573c0e581ffc58b99"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "ce914706722150dc35332ad3f21c0017b45303cf1c970fb8355061a7c740efd6"
    sha256 x86_64_linux: "c7f4fb3ad89b0de76e81bf7a80ef81c07065d3824457caf7a150490d7f9bbcb9"
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
