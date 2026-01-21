class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "4e2cb30de7eb6a546073f9b52e929ce84a2c9f8eb6df128e0f91832bf30380d6"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae6039b77b3fa76501c90df69336d4c566ac9ed35a96e69fe322b1e40c1a9b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6039b77b3fa76501c90df69336d4c566ac9ed35a96e69fe322b1e40c1a9b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae6039b77b3fa76501c90df69336d4c566ac9ed35a96e69fe322b1e40c1a9b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd44c3ffa2b10d8bb50ec60c80ecaca4549c2376d0a6d9543f2842c22704359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d078cdcf9d823f4ffba9a45386153c5d8e03b2dc135012b67738c1affe1081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb910a20bfd9e12a42e42f95317a2b31b04e0f342dc9d70a9f0c2e46292ca78"
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
