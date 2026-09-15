class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "68073d308273676f49183b7c34b09cefb3588916ada028b72abe7031862e5c08"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b42f5c1140d71ca91aecbe661ab31a62f321b00e267b17c82789bc0a5006e765"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b42f5c1140d71ca91aecbe661ab31a62f321b00e267b17c82789bc0a5006e765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b42f5c1140d71ca91aecbe661ab31a62f321b00e267b17c82789bc0a5006e765"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8dfd2276528434b90da9ad137ba27b66905e18c1bdd02538da309ee86b7e72db"
    sha256 cellar: :any,                 x86_64_linux:      "7fb2096f6dc8afe48508a85af1d27ad1efdfea19104e510e31f1c9a7f4c8f6da"
  end

  depends_on "go" => :build

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
