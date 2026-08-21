class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://github.com/dhcpdump-org/dhcpdump"
  url "https://github.com/dhcpdump-org/dhcpdump/releases/download/v2.00/dhcpdump-2.00.tar.xz"
  sha256 "41c79aa975662f33b1b7acaa0ab4c071b654cc78166c6475e82e3f0cfbe4b009"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7d8e967b3562351014a01c6158a8e84fa2aaa66eba6cda344148b7c1040e14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a5cf4fa7e3f43c35a0fc0f9bfcef0b6564cc22fa29705f6fd7c71968096195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c29f8cddc375fa941d9b2f7093001a09954a61fba0173e78f06f02b8bf3ccbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "edaea8254e1b3d8d0e1ce8cad5c7a6315ec3baeaa00eb38cc51d59a8722438f0"
    sha256 cellar: :any,                 arm64_linux:   "9dfb5f7053c6bfe261ab26affdc1d401bc953d3a1d3c0236b270853fd0baa08b"
    sha256 cellar: :any,                 x86_64_linux:  "0f42ecb8a2a6d0988124c7d03947f91027bb08c27ee8cbee6092e4022fe32bf8"
  end

  uses_from_macos "libpcap"

  def install
    # the interactive TUI (-t) needs yascreen, which isn't packaged
    system "make", "NO_TUI=1"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    # live capture needs root; this capture holds no DHCP traffic, so nothing is printed
    assert_empty shell_output("#{bin}/dhcpdump -r #{test_fixtures("test.pcap")} 2>&1")
  end
end
