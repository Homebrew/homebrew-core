class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "b3705f5933152bcf1c38ca6c1ee42c518c6d6a3c282a2841b98bdb254c591f4b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ec1f3ba496bd5bcf352c63870b97c532e37c8a357f3910772bc02d294d69143"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ec1f3ba496bd5bcf352c63870b97c532e37c8a357f3910772bc02d294d69143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ec1f3ba496bd5bcf352c63870b97c532e37c8a357f3910772bc02d294d69143"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3177f8dc65fc8add1f2968d089c231ff9bf79624f65455fa8fe2058bbfce3199"
    sha256 cellar: :any,                 x86_64_linux:      "5ec9dd63d79f5bf58ee74fb7fac652cbbc51e42ce9e5ac54ca06a76bb422adaa"
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
