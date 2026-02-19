class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "3db027a4e5b7ce6baf4e3c777786612a9eb51ca5da239727e5d464015a90f4ed"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "552d2b24fd6d24818b76233b3edcc1a5a13806276d5bfa4ef7a225e5464b5d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552d2b24fd6d24818b76233b3edcc1a5a13806276d5bfa4ef7a225e5464b5d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552d2b24fd6d24818b76233b3edcc1a5a13806276d5bfa4ef7a225e5464b5d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6636d595bfb8e46a9ea4e3232b4622fdd8ad61723888e310b6f76161700c1fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36fce66483fecba29ae13ecaf38b410350b34b84c8db3c346f75a48073ee0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b6a1ffe071e41b70f8f4e246e526a5a71760289c7b53a6f90ec0afc65c2a11"
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
