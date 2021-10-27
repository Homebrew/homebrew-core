class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://wiki.linuxfoundation.org/networking/iproute2"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.14.0.tar.xz"
  sha256 "210fa785a52f3763c4287fd5ae63e246f6311bfaa48c424baab6d383bb7591d4"
  license "GPL-2.0-only"
  head "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "f5d54b7d5e597d1898e2f51be8236b00ad02754bcaf741299ea31e0788ec2505"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
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
