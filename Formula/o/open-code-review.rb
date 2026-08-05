class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "5eea404758f8972b420526650f5d32f06668090ae5a957570f0c13befaf3e182"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0881b544dbeaeebe08b4aff6aabf768bc5dcb3e8dcd0d41b0dd0b4e7c7e17e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0881b544dbeaeebe08b4aff6aabf768bc5dcb3e8dcd0d41b0dd0b4e7c7e17e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0881b544dbeaeebe08b4aff6aabf768bc5dcb3e8dcd0d41b0dd0b4e7c7e17e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "643250c8108921cf43718ea962eefaa99b268d421cd5ef45d239333308b4005b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a1a3df84f0f9efde69cdd759269f28f7612def79a67738674c038009121454"
    sha256 cellar: :any,                 x86_64_linux:  "c20fed5076b1e998ef1862f8581b98c2b161e9c003d87bd0349875efea9726bd"
  end

  depends_on "go" => :build

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
