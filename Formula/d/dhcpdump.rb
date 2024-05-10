class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://github.com/bbonev/dhcpdump"
  url "https://github.com/bbonev/dhcpdump/releases/download/v1.9/dhcpdump-1.9.tar.xz"
  sha256 "3658ac21cc33e79e72bed070454e49c543017991cb6c37f4253c85e9176869d1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab4719be570abc658b8f8f46de37bad273e2b2389b0d1816bf38b7f1e28c0f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e61cb0d3acc83a1c2c2ffc1f754b8017c05be420a7844e19fb17a5326365d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41867afb73da85099eb1560fbea4872835ed2dc6117af80932cfb2e2a7460276"
    sha256 cellar: :any_skip_relocation, sonoma:         "b28f0b506d481178f9cd43f93b6ef13457b00d75a110424e1f1745c3de14c57d"
    sha256 cellar: :any_skip_relocation, ventura:        "72f552b14bfaec81d3210ae49740a90bac27dbb2fdc1e262113e5a39588bb475"
    sha256 cellar: :any_skip_relocation, monterey:       "e43375872f07ce0af9ac1eb2e8a32e2adc40167ca60a7f1f0ebcc627d6e06d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3b1f52c2fff495c9471cd218859780da46406aaea23d148b34220d8833e5bd"
  end

  uses_from_macos "libpcap"

  def install
    inreplace "Makefile", "-Wl,-z,relro -Wl,-z,now", "" if OS.mac?
    system "make", "CFLAGS=-DHAVE_STRSEP"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    system "#{bin}/dhcpdump", "-h"
  end
end
