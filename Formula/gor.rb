class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  url "https://github.com/buger/goreplay.git",
      tag:      "v1.3.2",
      revision: "05ed82129775549a4f8349edaaad11ec2d5aa791"
  license "LGPL-3.0-only"
  head "https://github.com/buger/goreplay.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a644ae3099e15971976fbfd1500abc91384cab76ab7dce1a142cd2a8b7062209"
    sha256 cellar: :any_skip_relocation, big_sur:       "91229d9994e4e18c0f5ef3677db46d9ff88fadd996b614b1d54d3b5060c02f44"
    sha256 cellar: :any_skip_relocation, catalina:      "184110bd3cc16c192d4389a12cc2b96b515e0839b0b59a2120fae4c6abe6e7a7"
    sha256 cellar: :any_skip_relocation, mojave:        "3b95b1e0101ca612faaca34ab4d4a1e4e291a14d71be890921d1af16d1a59664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0ca7bb9a0e13f6e05e92a22c1ebebdfb32cf02df1d87aa8ba614dcdd877196"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "libpcap"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version}", *std_go_args
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end
