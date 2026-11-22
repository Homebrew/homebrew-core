class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "4693797f7072d87eb7c02cd9bd009069a52da259497cd51e7c8f6aee5df71185"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    manifest_sha256 "0ae70d29011986f787a849a9384d4f6e5d880a64f635698ab9c04d3b66f6181c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07285d2e57e53f38fc8e87fa86de7b59748ea6c5668833e237002ab1242704da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07285d2e57e53f38fc8e87fa86de7b59748ea6c5668833e237002ab1242704da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07285d2e57e53f38fc8e87fa86de7b59748ea6c5668833e237002ab1242704da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "693fc18ed12201c08ab9ee70187e7d71c9a7b5a2848276681a43ae4dfd7f36c3"
    sha256 cellar: :any,                 x86_64_linux:      "1cb86c630ecfed381d85f385940efa674faf924d98a3ad5e317e2f24f5a457ce"
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
