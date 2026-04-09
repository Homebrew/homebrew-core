class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.61.tar.gz"
  sha256 "03c4801b6d632a22f04de4957a0babdd73b07a1ee991c92ec1b6504b24b1a802"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc861cf26165278a03f3ddfd5b863afdf328f7ed35cc867a7aca8f3c15994ae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de92149b030c3e26a725c7aad50d40e4d31c68ea6a6ea679764b2d4e8e57257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8078f0bfa85b57b507f06dcb62c936c54c96513aae7fc520c4e7052e2d7b6e25"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0a353111809406ce9b7deb3283392b9ea4c31576bfe7e948529de489dd5b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d456fc7f9a29e17c9332d2bff734648deb2a14865112510aa1643a3ff78456b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52b4941544d53a29695aca8117554a54b6986ce413353d04f3fa2561e5d8698"
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
