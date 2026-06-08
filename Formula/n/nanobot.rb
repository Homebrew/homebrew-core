class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.84.tar.gz"
  sha256 "3c7010fffb1e62049e0552a3c02d88cd881af22be4b5e48328bf290145a90449"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "555dba1e73e9dfe3bd62ed4907bdf9230feaa770972ae0f787b6aec4c87b17ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecf74888a99861c852304f4f729d702922e7c5ddfe479df5d1b0b394c582b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aae9e0d289979dda3739a594f8e685436f7c0605509df649de8224f354866a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c05f5c0b1e22a48c42e7713a46a98afd2f85acc41235da23b343eb92661cd55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d659ca9210e855a60ae17aaf4bef6e867867c686dcbb9c48ca066ceb1c3fbc"
    sha256 cellar: :any,                 x86_64_linux:  "a461049e8729f82962e486cb49275ac1f557c7858259e3c523f9b1b1b8122ac6"
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
