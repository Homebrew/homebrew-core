class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.90.tar.gz"
  sha256 "1b70f43c3553696267ead009f32b2b2604361f9d7f1093ce51b5bc9926ee0346"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a563519337231dca4c0e9a6475727d15d6ecf5cff504dfe273f3dbbdb2c6cb87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6c207ec6604ec82565d2229f1a2c9fe279106bdb9589b98410a3894b602dfc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "594e7fd19cd5c71d37ccdf29a8a5176495b2a24c95361d5fced35b346503a27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddedd86743bab07b1a3805ea96d013267113897832b385dd27429e8154abc326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43de702280fb05956295d77efd7ad713c5793bff2f44f66081e2e3b12d93e43e"
    sha256 cellar: :any,                 x86_64_linux:  "4a7c1a8ce9b4c1d3fd50b6fd049ae7e5c93def7a0bb9a9e78734ecf70dcaf645"
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
