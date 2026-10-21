class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "d47d037d9dc350b18a54d253ab3519211aef8f3a50fc0e3ce3f3b36c68f773ed"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fba81d1904294a842cc2e260f350c76fcbb072843d69cc531246e6a3de00a1f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fba81d1904294a842cc2e260f350c76fcbb072843d69cc531246e6a3de00a1f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fba81d1904294a842cc2e260f350c76fcbb072843d69cc531246e6a3de00a1f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b401488b3983372bfaf4cd651c349df59b43494ed09ad36ce5517a1be042bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1e76bbc3e5b933df96169ff5a22fc9b83f0d4dd00fc9a363b060a05972318e80"
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
