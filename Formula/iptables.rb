class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.8.tar.bz2"
  sha256 "71c75889dc710676631553eb1511da0177bbaaf1b551265b912d236c3f51859f"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 x86_64_linux: "3924660d88ad974260e7b6b5d2bac9a724a94daa2b1a301f457db368fe1cd2fa"
  end

  depends_on "linux-headers@5.15" => :build
  depends_on "pkg-config" => :build
  depends_on "libmnl"
  depends_on "libnetfilter_conntrack"
  depends_on "libnfnetlink"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "nftables"

  uses_from_macos "libpcap"

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
    assert_match "Permission denied (you must be root)", shell_output("iptables-nft --list-rules 2>&1", 4)
  end
end
