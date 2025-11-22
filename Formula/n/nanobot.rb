class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "48ca8369239137879fd259acbdd5f6a69043c6055a29ab4f7678369e229f0e89"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdc46e93544303d796defcd10aa0a570ba3356b3dfafa33717a1d128693ee24c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884c488e718b58315e46d2f3f914b4c2eb20189385c2652716257ae95968b44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09329353c66ee98bc43c928857b4d5f48fddc7b0c1c2e2b155df26b879e0b283"
    sha256 cellar: :any_skip_relocation, sonoma:        "e637470fa5782bb935ead306b3a4545fb717bec863ce90769ddc97b9aa0179eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386e23b4bf2d73732b9ddd01442b038e2d4d6b51653e7fe118f6f311a0a31fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f50173a08f428c64745e2441ffeb8cdf4b63234778253f3b556859622a39a93"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
