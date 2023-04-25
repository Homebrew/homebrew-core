class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.9.tar.xz"
  sha256 "ef6639a43be8325a4f8ea68123ffac236cb696e8c78501b64e8106afb008c87f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "c51bb8a5dd82a11b2230095f7152092497e8d868d0a1ea76de6b48f81556de05"
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
    assert_match "Permission denied (you must be root)", shell_output("#{sbin}/iptables-nft --list-rules 2>&1", 4)
  end
end
