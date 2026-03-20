class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.60.tar.gz"
  sha256 "18ffbc725be7da04ab91c6f3996bd0d71a23b4a57138f7ac76115f2f5207904d"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fb76e4e3f90976f5fa2b38c95291829fc34aa05014169b344a7d80429a48af1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c719b65446c2e585b34ee2dc276270b0f7b07a30494effb66e13619b8ba424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f7bde6ccc04f24614fbf4b92321213aaed7fed2260858e6fa5d47c28b4e720e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0555608676ece1a6ddde2dcfd9e5b691c5d585578d36b5494f4e60dd127f284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c936b54832683feae278608ccb72f3cd2d97b4f622aec7ba00117280bd471d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1f2215d51370cf6ad844399b1a35d35ecb64f6ebbb37faf7396783237bf729"
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
