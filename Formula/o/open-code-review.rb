class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "0710bb01ad93dc59cc83f4357d8c02b22375a47c4de2093c643b66fc03a34811"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "730eec56f07d68891995dcc28a455c6b85998b52b8e5ceb14e07b998890d93ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "730eec56f07d68891995dcc28a455c6b85998b52b8e5ceb14e07b998890d93ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "730eec56f07d68891995dcc28a455c6b85998b52b8e5ceb14e07b998890d93ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "55b20a449d228669377a325a3f3760cbab9eb46d60a0058a3a1742550d38e767"
    sha256 cellar: :any,                 x86_64_linux:      "27983e6b5a895d8a5b96988036195dba57aa4019c74a4fd94c6399cf2938ffe0"
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
