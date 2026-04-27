class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.74.tar.gz"
  sha256 "6c1ba39ab86a0a6527576e290e0bc69f6af93da1629b04aba7ea7a55263f5c09"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82e4cc42752a4c82684fc191f87fd97bce96f9c2c94c08d0142672d3dcd7b321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2889d92f9fcb11fd70921f906a4271840b6bf65b4ba02ab75a7a29c1b869fc28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b61520c760ce861b56c5bf6a3ae9e45fdf5615070fd73bd27d387a116a9602f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4adc3bcdfc77dbb87192d5cba7cbe5f3347d814e1e4d7aa9cac3f738d0dc3ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ac8917a4b802394636cc97ce2570b039cbeb4ba6a10738d76e3654894e72e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd3c01a384073e794757d81265c777b9c46afc6aefada94d69cb0201657f4b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
