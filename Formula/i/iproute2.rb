class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.18.0.tar.xz"
  sha256 "6ba520e1975e4c50dc931eeae91ea37c198b8a173744885f8895b84325f9d456"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"
    regex(/href=.*?iproute2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e7a500a0eb4794ceea637bd3120a55f7a5c51a929f8e9244ac32e83a9e10e66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20878f94b38d55d21a0900a3fd75356080dfd5929db88680b6b2e520d6a2e910"
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
