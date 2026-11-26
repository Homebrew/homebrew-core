class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "9be8741c0c7c73a807c3e01a172f00226598c6246c597add462365a528cc2254"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    manifest_sha256 "16cd677f440f5241c51a8dfa0b0d3820e82857e53d3aeb2c0a8ffc0eab9a2b93"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d7c8e8ebf61763b6100c45c7db14e5ff6567aa8ded028bd459f2f14fc7d3a85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d7c8e8ebf61763b6100c45c7db14e5ff6567aa8ded028bd459f2f14fc7d3a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d7c8e8ebf61763b6100c45c7db14e5ff6567aa8ded028bd459f2f14fc7d3a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c097eea52a95381a8bb4a8ec159314a88d6ab633de17eb6b6fc344d244c2d11"
    sha256 cellar: :any,                 x86_64_linux:      "d3327f0f16592b0156d331ca8816679e5e6ab172f466b9bbbf5c348cadf2fb8d"
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
