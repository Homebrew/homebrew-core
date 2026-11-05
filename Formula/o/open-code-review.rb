class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "6152a3a57c2c8769c6bdbbcc5b7219a97742ea380aef2c1b9e777f482f677154"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d50341185c83753855178c8bbb6e1025fd8fd9357aad8bc08f3fcafa5ebe8226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d50341185c83753855178c8bbb6e1025fd8fd9357aad8bc08f3fcafa5ebe8226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d50341185c83753855178c8bbb6e1025fd8fd9357aad8bc08f3fcafa5ebe8226"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbf9e4b2648a6e395931dd460e545ded91e391bfbeb4eabc687c0b458cec4072"
    sha256 cellar: :any,                 x86_64_linux:      "a7561f9f73291d5d12aa95fc9665f4270f6d2a0b643de0606acd00e8830f16bf"
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
