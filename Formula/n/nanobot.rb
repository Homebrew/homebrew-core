class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.64.tar.gz"
  sha256 "d89107e87c2151123cecb477b2371e1079f21c702453a8d7be047807c455d0dd"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0356876cb1e16446700cab53c0d0b5a057acbb38b181c4c010f2cdf897f776d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e09e3c16db6516c8e98fdd973be1814110a4fa2de6b27db43673cea5799e6a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb84d6e20ad494d0dab935d11c7357084770560699a015d7c845b3422d0365eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "37c253849c3665ab9ab22ba8357387dda917340f4a65533f690736fcbfffddaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297ccb32606606c1f1948ba601adeff873cfb65814cad52a1254a43983ab7099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5554e075c89c6170525cb35f3d242c58388e4aeb5a261a5ac9bf08dc4fcc552e"
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
