class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.9.0.tar.xz"
  sha256 "2f643d09ea11a4a2a043c92e2b469b5f73228cbf241ae806760296ed0ec413d0"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"
    regex(/href=.*?iproute2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9125deb24c928531ed818536fdaa5326d267e662fdf16d50da7d1b604421947"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "elfutils"
  depends_on "libbpf"
  depends_on "libcap"
  depends_on "libmnl"
  depends_on "libtirpc"
  depends_on :linux

  def install
    system "make"
    system "make", "install",
           "PREFIX=#{prefix}",
           "LIBDIR=#{lib}",
           "SBINDIR=#{sbin}",
           "CONF_USR_DIR=#{etc}/iproute2",
           "CONF_ETC_DIR=#{pkgetc}",
           "NETNS_RUN_DIR=#{var}/run/netns",
           "NETNS_ETC_DIR=#{etc}/netns",
           "ARPDDIR=#{var}/lib/arpd",
           "KERNEL_INCLUDE=#{include}",
           "DBM_INCLUDE=#{include}"
  end

  test do
    output = shell_output("#{sbin}/ip addr").strip
    assert_match "link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00", output
  end
end
