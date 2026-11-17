class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.11.tar.gz"
  sha256 "67122e5ed3e2f5cd1baaf45cadd9045527a4ca8cbe352cd6db907a18ae6afd44"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "327ec1cd89c5f4075f852ecac2df06decaa36235e6eec520c3c7be1623f01422"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "327ec1cd89c5f4075f852ecac2df06decaa36235e6eec520c3c7be1623f01422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "327ec1cd89c5f4075f852ecac2df06decaa36235e6eec520c3c7be1623f01422"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1c84adc18c29ecbc98f1fe5058dba6aedf072ad5f127a827d407ae6560e5e73"
    sha256 cellar: :any,                 x86_64_linux:      "2053ce4298de22f6b989fee470c15730a9431c874bf8c83d8ccaa13dc27e61db"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
    generate_completions_from_executable(bin/"ocr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    # "rules check" resolves which built-in review rule applies to a file.
    # It runs fully offline but expects to sit inside a git repo.
    system "git", "init", testpath
    (testpath/"main.go").write "package main\n"
    output = shell_output("#{bin}/ocr rules check main.go")
    assert_match "File: main.go", output
    assert_match "Pattern: **/*.go", output
    assert_match "Source: System built-in", output
  end
end
