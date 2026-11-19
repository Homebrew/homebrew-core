class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.13.tar.gz"
  sha256 "15cd57954ea498d20c4384fff5d35b52b4e2a858205cfd52fa37f319b5219865"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71d197a01d0a2be07cb98732d634d90f24a9c2370a46c384ac9e416786fbce26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71d197a01d0a2be07cb98732d634d90f24a9c2370a46c384ac9e416786fbce26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71d197a01d0a2be07cb98732d634d90f24a9c2370a46c384ac9e416786fbce26"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f71df3570f642cc801fe867e47dd289e6732297498b0d2098b616030481ce4d"
    sha256 cellar: :any,                 x86_64_linux:      "f7fca7da3ba81f0afa65cb53e147a3a96fadaa42e346b5dcd3316e5e8f9a8968"
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
