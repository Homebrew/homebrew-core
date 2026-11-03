class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "329e8d8b9eb9057c8d7acfc99569d61e3411d5ef4bc0bbbb4c3b4a873c4a0ba8"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9973486cf77677d16d3b0371f6bad25b12001ca18e30e9a2b1b8518ba2c9ab8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9973486cf77677d16d3b0371f6bad25b12001ca18e30e9a2b1b8518ba2c9ab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9973486cf77677d16d3b0371f6bad25b12001ca18e30e9a2b1b8518ba2c9ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b39e2ec1027291823e596597663f7229bfe39b7ce1b5978f433fcf1bc6668bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0b5bcf168e4d1e5696edbcc04b7dd45a0b5ac39428a203eee7e350aeec4cd34e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/1broseidon/ketch/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ketch", shell_parameter_format: :cobra)
  end

  test do
    ENV["KETCH_NO_UPDATE_NOTIFIER"] = "1"
    html = <<~HTML
      <html>
        <head><title>Ketch extraction test</title></head>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
