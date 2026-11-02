class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "0710bb01ad93dc59cc83f4357d8c02b22375a47c4de2093c643b66fc03a34811"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29e5aea63ae25b925f1a1c0376ceca21fb6cf27586b3949748a43eb47d231e3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29e5aea63ae25b925f1a1c0376ceca21fb6cf27586b3949748a43eb47d231e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29e5aea63ae25b925f1a1c0376ceca21fb6cf27586b3949748a43eb47d231e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4bfdbfb86b4d36a5ebf0876551a1525f28a9450f9090b10262bdeeed2cdb3edb"
    sha256 cellar: :any,                 x86_64_linux:      "47fab2e6636613a576f91d9ea2f87506fc2eecca6466c94af979847970c98130"
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
