class Llama < Formula
  desc "Terminal file manager"
  homepage "https://github.com/antonmedv/llama"
  url "https://github.com/antonmedv/llama/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cf6fe219f2554c90aadbe4d0ebb961b53fe3296873addab1a3af941646e19ca2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3450098c5433d3eb18f6457fa26f1a037c88e583a03b03094b7a55dd2680c0d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3450098c5433d3eb18f6457fa26f1a037c88e583a03b03094b7a55dd2680c0d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3450098c5433d3eb18f6457fa26f1a037c88e583a03b03094b7a55dd2680c0d5"
    sha256 cellar: :any_skip_relocation, ventura:        "7e203ddd4320263525c048c53049baa9a3a70d8eda8c17694d70530003e6f33b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e203ddd4320263525c048c53049baa9a3a70d8eda8c17694d70530003e6f33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e203ddd4320263525c048c53049baa9a3a70d8eda8c17694d70530003e6f33b"
    sha256 cellar: :any_skip_relocation, catalina:       "7e203ddd4320263525c048c53049baa9a3a70d8eda8c17694d70530003e6f33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f8a283c4f3f18e0e0baae519e1c2d52dabb1b4d6fd0967401cea70ad11655d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"llama") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
