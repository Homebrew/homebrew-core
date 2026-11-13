class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "f67ea28a3ada6055435d4bdf41f2355d4df7a2a3c393d2e36d9e075e15223777"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e63cc7323152548fdea4734a641838f6044fdc1fc2ccab67b921c6ccbfc5e25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e63cc7323152548fdea4734a641838f6044fdc1fc2ccab67b921c6ccbfc5e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e63cc7323152548fdea4734a641838f6044fdc1fc2ccab67b921c6ccbfc5e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fbdede043b53f353e90b19da2c9a5c4792082c9747d9d91541970a77f51f273"
    sha256 cellar: :any,                 x86_64_linux:      "9f2c3a324802b0a5e9e05ebe64052a972d44636c3cc81d766729b9d8e987e4d8"
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
