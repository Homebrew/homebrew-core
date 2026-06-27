class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "6886326544ae0acb2769c269fb4f635658ebae9d12e7692b31574c987f254563"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2e85a7a12fc06202c3ba5dd43bd0e2c14e989e29cf21b1a653144cc57636bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e85a7a12fc06202c3ba5dd43bd0e2c14e989e29cf21b1a653144cc57636bb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2e85a7a12fc06202c3ba5dd43bd0e2c14e989e29cf21b1a653144cc57636bb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d9c2c885d3c4be73693abbf5435eb0d7beb9a66d31083df077fbec8206a1de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b578c86a5b89a82f594e64dd23bf9f852dafa646d316fd0db8d69bdda58d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9581ac478387a060456c7891acd3fbda8e99a95ae2701dfcfa444a9f448477"
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
