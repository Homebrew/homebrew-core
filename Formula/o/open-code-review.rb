class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "01f9f70263825df1b62713d428c8de8d2c3a60ff49e5499b076c4aaaeb4efe22"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    manifest_sha256 "52d34a5cf2ab214a38183393e7f66ea47172fe5c8f8d4cfd455ebbe7b013fedd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e1c7fa536c61acd9bb3076691fdcbb2a56bce3df8b7f64e368a414e797bdd69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e1c7fa536c61acd9bb3076691fdcbb2a56bce3df8b7f64e368a414e797bdd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e1c7fa536c61acd9bb3076691fdcbb2a56bce3df8b7f64e368a414e797bdd69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "999acbf6320553b0446b74660599b6d54abdb960b46cb51ab102b7e54f5ba260"
    sha256 cellar: :any,                 x86_64_linux:      "c9ed78f665357f3ac731559b20c007b6745943b1d74e9b4283eb345842a670c4"
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
