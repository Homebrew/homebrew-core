class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.10.tar.gz"
  sha256 "93ded9d7f62a0bd9651f1a3eaf52b957b42baf37a1193e619004fe5af4a57bc9"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac3a7c9850a0c7a70a5de433d17ca515e03e8f0974d622cf445497b86bca7aa8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac3a7c9850a0c7a70a5de433d17ca515e03e8f0974d622cf445497b86bca7aa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac3a7c9850a0c7a70a5de433d17ca515e03e8f0974d622cf445497b86bca7aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f7910653b0d3a8a563817c038d652fc8848327a911e5d9550bd3b60d77d2539"
    sha256 cellar: :any,                 x86_64_linux:      "481ebe1a77b4893267a96afda79246cc3d742ee191c8d2b758085bcd47e97624"
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
