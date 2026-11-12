class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "2c4249c3551dae233d4c70274b785ce0b74bbcc78e5b56d0a6ef65b7f8501dcf"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee17fc6437f5decc45a91000ef9933d7f903445ca26aa2d4d7ec4e834e865dc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee17fc6437f5decc45a91000ef9933d7f903445ca26aa2d4d7ec4e834e865dc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee17fc6437f5decc45a91000ef9933d7f903445ca26aa2d4d7ec4e834e865dc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f45a695422b973413e10cbc85df89f8f76eb48d69dbd2dce460bb8b848a7675"
    sha256 cellar: :any,                 x86_64_linux:      "233e82feef6bf0b2ea49f85558b9b89703e088f494061c11b2b9baf8e712e3a7"
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
