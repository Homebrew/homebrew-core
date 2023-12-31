class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.10.tar.xz"
  sha256 "5cc255c189356e317d070755ce9371eb63a1b783c34498fb8c30264f3cc59c9c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "0fa05e2dceae6e0e09db597382c5940cf41176ab6bd5f092d654bcb7551205b5"
  end

  depends_on "linux-headers@5.15" => :build
  depends_on "pkg-config" => :build
  depends_on "libmnl"
  depends_on "libnetfilter_conntrack"
  depends_on "libnfnetlink"
  depends_on "libnftnl"
  depends_on "libpcap"
  depends_on :linux
  depends_on "nftables"

  def install
    ENV.append "CFLAGS", "-I#{Formula["linux-headers@5.15"].opt_include}"
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--enable-bpf-compiler",
      "--enable-devel",
      "--enable-libipq",
      "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Permission denied (you must be root)", shell_output("#{sbin}/iptables-nft --list-rules 2>&1", 4)
  end
end
