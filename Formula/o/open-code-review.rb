class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "19b8a062af3d8ba9024063852f094f9bb090800557ba327565283fb033a67c72"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    manifest_sha256 "a83092bcef2c11fa00339a5f23e6669fd9c12e7adda7afefdb9e0cda1c325864"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40ff017c016ec10ed524853f5f0f586874af9c431693aa54ee12edeba54abb15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40ff017c016ec10ed524853f5f0f586874af9c431693aa54ee12edeba54abb15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40ff017c016ec10ed524853f5f0f586874af9c431693aa54ee12edeba54abb15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "580a8bbb5af0c6fd03718ffcffc1441f94f357f68607838a83bda5a96215b7af"
    sha256 cellar: :any,                 x86_64_linux:      "6c296ce71300fe7924af5fba8a6d451948ee42ba4ee5e8e1d3ed4b1183167e18"
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
