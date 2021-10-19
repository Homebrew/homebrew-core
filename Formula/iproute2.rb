class Iproute2 < Formula
  desc "Linux routing utilities"
  homepage "https://github.com/shemminger/iproute2"
  url "https://github.com/shemminger/iproute2/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "16b79e6ce65d4d5fd425cef2fd92a58c403a93faeeed0e0a3202b36a8e857d1f"
  license "GPL-2.0"
  head "https://github.com/shemminger/iproute2.git", branch: "main"

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
