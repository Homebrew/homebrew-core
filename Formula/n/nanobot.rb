class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.91.tar.gz"
  sha256 "cc0ac449b6aef7827d7db936db727c412bbe409367049028452df8fe66ba25bc"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f7be1dde01cb27bcc982da49696273c1201fd45cadec947c52934bc4b40bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aba7f2569dce7bf864158a7209f7e013765d4af74bb9fa101e7b784d4a266a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad43f8225943a1512ce1cb68599f41c68e87b036b58b36976d1d4ce711f144a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc977814b799758707ae0c1b9e74c144874aa9d9014f085ea994e8e12dd9fc4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1440317bce4ed96dc03447c82863c521dc528951866283067595341f2951fa1a"
    sha256 cellar: :any,                 x86_64_linux:  "3c72c972835bbd3b56a18c5660348ca7ff6583b942c63b411c46e1a2d4b8868a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/obot-platform/nanobot/pkg/version.Tag=v#{version}
      -X github.com/obot-platform/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
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
