class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "84e0572de8eab9fd977fe965316424e93f9f5744d415e7047b8fc50996792a81"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20cf29c0068d8d57cf6f93478c3bfda5596d14fecb050a6d559dc227c0984e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20cf29c0068d8d57cf6f93478c3bfda5596d14fecb050a6d559dc227c0984e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20cf29c0068d8d57cf6f93478c3bfda5596d14fecb050a6d559dc227c0984e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "824cd45797bb05a9b6e73a8fa1fe6bbd65cd2ebf1098d4ecb37ab5b6741f2e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfa6d12e73ddc96493cd34cbe781115aa30222876fdab9a165ea7d7dd558757"
    sha256 cellar: :any,                 x86_64_linux:  "35918ecd7f6df0ef5e9d1718c47d241f8e188dba909cb0f7941d6fbb80fc15a9"
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
