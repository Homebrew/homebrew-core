class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "bc8e08333abf7bbad98330397b0fdbe070fe43370b7121d154421d55e1f9f43e"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "966e7ade419779b76389ffc0c3b45bcdac4ff6c66f679d40ca1749589837a4d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "966e7ade419779b76389ffc0c3b45bcdac4ff6c66f679d40ca1749589837a4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "966e7ade419779b76389ffc0c3b45bcdac4ff6c66f679d40ca1749589837a4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59602bfe7aadf1dd67c490a882e8087667a58e525cf7a25e39c2d0bca227a8de"
    sha256 cellar: :any,                 x86_64_linux:      "f7ea82d8dc26c64dd5f3e3b5f3ffbc576221a584d5f636af1323d758f47bd978"
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
