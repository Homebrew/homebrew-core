class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "b05ab93891107beae8fba11c8e93fa1169c2a0ae9b43bcc47f6142c40cbe8167"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f19a7bc0b8f0e8e85c472798b9bf8699480d0b85361d9707d7441e3a5576664d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57cf07eba14f20c3e911d6edcc8937b205d16d41b27fed3a0fd1cb995bd459aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0fa4334b26ec53dc0fdbd7d42e72b33cd66a8ff54241be63947071a177a4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5dae88aadb394f7fe6e4d384759d9a99dc3a6027d2d594ae883ab1f97af00fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b97f0e073ee74df208149f74a0b5bfbce04ce6f56e041fa3b56420f7a6192df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc838c160e06200b17fde360ad8bb656995b41aba26d50bef4669c3c8473ab42"
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
