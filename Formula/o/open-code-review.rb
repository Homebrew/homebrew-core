class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "c52c33ab088b4e86295fc4dd7b3bc2bba5ec9e78af0a8527a8da2eb8b5e3c2aa"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e116fd7a392b8fa0f512f552d41d0f959a939ffb9c7681e5d09a7de97eafbd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e116fd7a392b8fa0f512f552d41d0f959a939ffb9c7681e5d09a7de97eafbd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e116fd7a392b8fa0f512f552d41d0f959a939ffb9c7681e5d09a7de97eafbd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32227790cfc10681ee85f4bb7677720b497e2f42ce84b0b949903999e0f2d60f"
    sha256 cellar: :any,                 x86_64_linux:  "1f2f68fc149cf93fa7b9efe52b014e939ae197744b72a148bb64f0fedba1b5a3"
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
