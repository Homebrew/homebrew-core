class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "74fe14fbe3edc7ac98dfc59a10d92d66829cf37c8c7aeb09e96dad4ab5c0c772"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "472bc8147283212fa4af0a09a8335b1eb8abb6c52e0b501607870899b24138cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b562c0ba2f4d92592100b0b982848e8d802b8eb082ad10a6503b290025d1a078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95beb288a30d5bdf02bffe0224d8b65ed15fdb44e74f97e6d77fa0c1bbf26a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f36553ab046bcfdd91d1f446a98dbc0ff8708f031db1a96b2a26c2981a0cb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "701dc00288a136c65f0c39a0205908387e7f8018bc87bdabcf9b1fa25fd12394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bae56fea86da81b32602ed19a96a20898ff22f5980d7989a211cb5bdccbcd1a"
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
