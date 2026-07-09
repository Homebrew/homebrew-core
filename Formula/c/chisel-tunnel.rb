class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "47271eedeebf5d2494e4422f9e7ab081d72f181eeac0d32a4ad50facf776d104"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e8b6088f642fef47245e537c49c0ce979c0b919f3ea9318df7c243c91a0767b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8b6088f642fef47245e537c49c0ce979c0b919f3ea9318df7c243c91a0767b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8b6088f642fef47245e537c49c0ce979c0b919f3ea9318df7c243c91a0767b"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f049c4492c24d1fda61972f957ef76ae99ac3bd2094cc080d3a249e3ab46e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b942ca9b032e84248bf4b3b94ff1aef52e45900d16f287025ab09661ea4003f3"
    sha256 cellar: :any,                 x86_64_linux:  "c4258c2603d0b1da22c9412b3c55733259e7c1da4a0dacd11992a0f25e7182dd"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    server_port = free_port
    server_pid = spawn bin/"chisel", "server", "-p", server_port.to_s, [:out, :err] => File::NULL

    begin
      sleep 2
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
