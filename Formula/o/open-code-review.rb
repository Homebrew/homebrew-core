class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "ff4e4ff4aeceb7332aef7f8d222ea51646c002e820e09a60db1ec108085181b4"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85754fb4f760ae51225daae712acb8f7d2947dc39952be7db5a632d8a357f112"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85754fb4f760ae51225daae712acb8f7d2947dc39952be7db5a632d8a357f112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85754fb4f760ae51225daae712acb8f7d2947dc39952be7db5a632d8a357f112"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0edb0a5cb58b0ea4066e5c4ef77c7dca502cd555ed95ff92415dbd7e8a8ba059"
    sha256 cellar: :any,                 x86_64_linux:      "2bce178367a59fa0952f8ca90523d4d44007c73f53c39f25e544313539e9cafa"
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
