class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "fb9840530ded8067622f3c91365300f02b1feccdb7a873e6397eb12d6ed6e01f"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3de233370f59a5f84654e61a4af6e35f3517bfb9b961cda20d0ba3e1504fffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3de233370f59a5f84654e61a4af6e35f3517bfb9b961cda20d0ba3e1504fffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3de233370f59a5f84654e61a4af6e35f3517bfb9b961cda20d0ba3e1504fffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f497fafc66bb9a4e0737fba12e080386ad340615f99bbc731926d5241ea867d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9518f6ffb5aaf38650c4b0e53617cab918ef07d0c39d0e2bd84a58c953d06fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8449448812523e7721f9980982a70c2b03dad75ba408697b48e55809637e0ce2"
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
