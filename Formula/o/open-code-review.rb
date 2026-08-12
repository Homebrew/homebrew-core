class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0f89e3e7c29a788eca37688599cd3c8f57e4f1be811feb2738fd7f1d2b987b52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272b67cd8aa4fd1db33f1bab07f579b0ffa2127b57ba1b925df6390014eb7ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272b67cd8aa4fd1db33f1bab07f579b0ffa2127b57ba1b925df6390014eb7ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272b67cd8aa4fd1db33f1bab07f579b0ffa2127b57ba1b925df6390014eb7ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e8465363fbbf3d9cc864b5cb8bedda0955533cacb67274caa38892dfa3c68f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea1e6390b39b5f4615a685b2535a7557188b934a00528f11bc6146740f1c76cc"
    sha256 cellar: :any,                 x86_64_linux:  "0e578bb3ebe2cf1f379ac1d54120debac6cfa3cfffea951c74ccfa4a03d89796"
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
