class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ae495121c1b369a4ec6b228bcb511bd3950f3fa7c074d00e6d6d304bf6df93bf"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "974772b1fef2cb434cfc2aff4097d86d1be35f283b55cf5034a3bdd2eb41081a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b013403462a8f88b2d31af075e4fcd745fda8368b6dc2b0954809416bf93f9d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b6a46e0a0138c76f9f9a77f78adced68ff77fb9349f3760fb59e8661eceebc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eac1ebf5e044a48688c2518a6c2a28123f44e466c79a77ad1119586fc84d2b2"
    sha256 cellar: :any_skip_relocation, ventura:        "b559a6da9173a1515dd86a31bf64c5539c42fffd5504657fdb538b261fcf0e27"
    sha256 cellar: :any_skip_relocation, monterey:       "661381d7f69abe46e634d683b7ed9456f77dc4f0f3f41cb82990ab6a8b3d2426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060e445e65f3e486e2dc88ab1332e439ae8734bdf26e8685e6a91395f6d9b736"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin/"gptscript -v")

    output = shell_output(bin/"gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
