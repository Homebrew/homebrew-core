class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.87.tar.gz"
  sha256 "23426b9c981e698365ee1b59405b3d13a4cbe8bdcd46f291ab574a9bce191955"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c910883329eaf9d49a9ca1fb468971a98248c5fb991a021431348b96cbbd23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6a0f4a30b7f235864ad89ca0df6a365ad1184efa9d0063c6abde939ecd1015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57bc807514c862a83d2f4728e07a87bee5bf49031f8ba8f5e27a6a78994257db"
    sha256 cellar: :any_skip_relocation, sonoma:        "650d64280c1aa20fb833cdd5427aeac096f3882d020cf0f68acbb2b95e438fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5777c697f226997d40e079e0e17c45939c2a695909ff565d051ac57fd21e5363"
    sha256 cellar: :any,                 x86_64_linux:  "54eecb042829ce51539a0435767f7c6624170716377218837a8a9f15b403c177"
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
