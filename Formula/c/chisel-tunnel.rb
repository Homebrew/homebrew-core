class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "262f568e1a10ad185b0cf5025cd549b636dd2938cc4d59b24bf89f3269ae7e33"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75f4280c60a7ef2eabd569f47bdee2124a9054590986dc753dac118a3272ccae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c87771870461e2fae82e20dc4a3be3d885eb0a7528bae6b5879b0d283fb4474d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c87771870461e2fae82e20dc4a3be3d885eb0a7528bae6b5879b0d283fb4474d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c87771870461e2fae82e20dc4a3be3d885eb0a7528bae6b5879b0d283fb4474d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "767ccd52ddf31e579637b24f08ae369f9397e5e59451277d4fc4998090da53c4"
    sha256 cellar: :any,                 x86_64_linux:      "c6f512bf8ee8d98be462dc08661a23f807a4db91ef3f1eecaa018095d73edd34"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "chisel-ubuntu", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
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
