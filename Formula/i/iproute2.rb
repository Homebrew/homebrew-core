class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.5.0.tar.xz"
  sha256 "a70179085fa1b96d3c33b040c809b75e2b57563adc505a4ad05e2609df373463"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"
    regex(/href=.*?iproute2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "593391f568a2ddeef2b154876e579e2fe537f4b9925fbda8f85647613e049e86"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
    system "make"
    system "make", "install",
           "PREFIX=#{prefix}",
           "SBINDIR=#{sbin}",
           "CONFDIR=#{etc}/iproute2",
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
