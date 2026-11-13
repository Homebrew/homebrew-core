class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "026b5022403fb34860074cc3951ee4566f7edaa94d63be58f72e844a6cf74a98"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c01e6a0c15b4b759d96546dc03bfdb874b18a86a6b5a314296717ea5c0f14996"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01e6a0c15b4b759d96546dc03bfdb874b18a86a6b5a314296717ea5c0f14996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c01e6a0c15b4b759d96546dc03bfdb874b18a86a6b5a314296717ea5c0f14996"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7dc90319ce5ec9c196cc122ff037630f81eac9631c60c5ff92f8e9bbddaf64b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7ed5eded50c6406b967c3fa5fffa8456f13f811892b66d92eceab898a61a5aed"
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
