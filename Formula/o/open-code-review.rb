class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.12.tar.gz"
  sha256 "030d06e2efecddb38481caa9df2c2d867f449d20567e579045e4cef39c66655a"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c6a59077299e3fd3dda024429454e66ae1bbec3b00a91236cc990050608219c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c6a59077299e3fd3dda024429454e66ae1bbec3b00a91236cc990050608219c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c6a59077299e3fd3dda024429454e66ae1bbec3b00a91236cc990050608219c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c938d7d7e993b80bd7281e4d8b6a164c1622a7b9dac5ae742fae8466dc7b735"
    sha256 cellar: :any,                 x86_64_linux:      "978517f12b3dfc6c8a7230dc12eceaeb066a4d8c5db1169ab91e97a7a224a658"
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
