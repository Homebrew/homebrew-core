class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "2c4249c3551dae233d4c70274b785ce0b74bbcc78e5b56d0a6ef65b7f8501dcf"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00071914ba4b2297dce8cc54cd79ca67df9ba8e04562b75d635a3ad029a6dfaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00071914ba4b2297dce8cc54cd79ca67df9ba8e04562b75d635a3ad029a6dfaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00071914ba4b2297dce8cc54cd79ca67df9ba8e04562b75d635a3ad029a6dfaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3467b5de5ddfb41a4545356dbe4014201c21a5864c138b30da594a5499b8303d"
    sha256 cellar: :any,                 x86_64_linux:      "3b7f9d61dc895d6b20bb519db7a0f8d88658481a1241f12213fff6a89644bc5b"
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
