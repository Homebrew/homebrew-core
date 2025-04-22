class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.14.0.tar.xz"
  sha256 "a6d23588150096591c3d00fc27a324a82ee71d7a1a9eea78df5df17ad9b8461f"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"
    regex(/href=.*?iproute2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e3cf1ba66e83b59f23e34d23fef8830d0182b04b4569634fb82f6de6f934cc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19e435ed304dd274e814a3fb09a03d33418faaccbed672101ef5ca81123d487e"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

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
