class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "e6a69f15e74c13b3ef455b2df4e51d69d88057f07ecf2d64f20d4a02673a1756"
  license "Apache-2.0"
  revision 1
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29feb3265b0ca3507036885b88a98c00e01364812428285cbd0433be1363b8b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29feb3265b0ca3507036885b88a98c00e01364812428285cbd0433be1363b8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29feb3265b0ca3507036885b88a98c00e01364812428285cbd0433be1363b8b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e22b0c7070ddceba4b401841f155b837cf0ac9625438d3e161c3ff925304e60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eae8578f3bedbd24c9cc181c4b4a88c184c6832e38b6dd35d6c00eac6d4bd5e"
    sha256 cellar: :any,                 x86_64_linux:  "06ac55941a382949d36c1af489be86fc49194a474c7831f5ccaeb7aa54c28bfb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
    generate_completions_from_executable(bin/"ocr", "completion")
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
