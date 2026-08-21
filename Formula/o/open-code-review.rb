class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "883e123efbb17ff2c6c3eff0ae1b778fca84c41189b592580968aa3f67a6b98e"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08080dc98f3f493b725d62ca35c2e1bfc9fdf8bd947efbfef2f3243419a32d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08080dc98f3f493b725d62ca35c2e1bfc9fdf8bd947efbfef2f3243419a32d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08080dc98f3f493b725d62ca35c2e1bfc9fdf8bd947efbfef2f3243419a32d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f73cc345bd702312a194e6a9a506331e1af3fb7bc7e07bdaa3844d430523cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c58527e3d9e70053fc24222425197998d81d4fcb13c40cf541e5f80598dd8c"
    sha256 cellar: :any,                 x86_64_linux:  "8c61f04c23bbba59e4c782f410219b1269232a241e9f46162ff0d0b140017504"
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
