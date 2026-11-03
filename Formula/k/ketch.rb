class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "329e8d8b9eb9057c8d7acfc99569d61e3411d5ef4bc0bbbb4c3b4a873c4a0ba8"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3accab31235a8bf08e967c95aa070a63c780cea0b6b393ba5809d63165701384"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3accab31235a8bf08e967c95aa070a63c780cea0b6b393ba5809d63165701384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3accab31235a8bf08e967c95aa070a63c780cea0b6b393ba5809d63165701384"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "280820c46b6ae2067372c39bd8daf294766e0a2f08ff1557aba8eb9b1c027ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1b37d7bc123c420da6ee909d9c6b1feb1358b41e79045709ebd11c43acf01709"
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
