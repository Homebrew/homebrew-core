class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "d5614f0debbc0b6a4666182eaad2df70edf9480ef415086b6a35c0520e233b2a"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "486dd553106b3f98c1bfa2125451793f7553eecd7fffaa5d6b6a5ef062a13621"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "486dd553106b3f98c1bfa2125451793f7553eecd7fffaa5d6b6a5ef062a13621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "486dd553106b3f98c1bfa2125451793f7553eecd7fffaa5d6b6a5ef062a13621"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d4a72d597186e95cb2013126228c3fc30f6402fc819fa1f4625468fc9c41496"
    sha256 cellar: :any,                 x86_64_linux:      "0939dceb76876890ab934164b121732327e6baa3de9627fcd9edf91fcef42da9"
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
