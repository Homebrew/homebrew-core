class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "79874354530b899576dd4866d3b1400651d0b17c1e7a90ad30c44686a0642600"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "925d5ffa1c7f6ffd0c3743b6805308bc39ca041e1c7e93c1333848699f5504cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925d5ffa1c7f6ffd0c3743b6805308bc39ca041e1c7e93c1333848699f5504cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925d5ffa1c7f6ffd0c3743b6805308bc39ca041e1c7e93c1333848699f5504cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d199aadd5a88043ec9f8bffd7de6f852dafdf4a45fac5a8d3527f7ee489efa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68d6e4500a83ee8cc60afed486e32e9b6320b5566ce7836b69148627272493d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e887113b6a3f3715847a8004c6b9d8708212a69cac3ddcaed42eef3d3f148d"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec bin/"gost", "-L", bind_address
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
