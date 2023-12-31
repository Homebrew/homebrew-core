class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.6.0.tar.xz"
  sha256 "8738c804afd09f0bf756937f0c3de23117832a98d8cbbf50386cf5005cd613ce"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"
    regex(/href=.*?iproute2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17fd0334f62c219c1bc18363355e3fddf367324a7b8bb694336761ef29783db6"
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
