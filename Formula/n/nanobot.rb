class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.92.tar.gz"
  sha256 "1392bd7ac4e93ff25bb0e42c44416674f408ea698208bd11ae6664d3936b9a97"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c1b343a99644071dd99df10a4f80561230212e092c67905f6c3a3e71d4d1d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bef8fc765c60209df6b4a5cfde9b1dd95e3d98236ee712ef62cbc6e7cd6056b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5dbf4c091f6c730b7385df3f3ca263c8342836bfc2f8bcf87bb4e041a14e0eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "356edb817b4b6183a6596f7673794e42c60fd6e2b5d6aa9103fb9f465f09be57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fab8ebdcfffc6f02b6e38120c7c80a93df343d0da00debefb8cfe76b5ff4dc0"
    sha256 cellar: :any,                 x86_64_linux:  "02c107f62ab252df059dba9f3a092e28272bcce9d157de2e4d49b5d9e9e0d85a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
