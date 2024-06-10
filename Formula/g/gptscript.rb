class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7c40a673031e77824628391dc266ff145d6d9b8d6304987c43a2406585b7ce5c"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2070b89eb4a5d269ead3ef01daac10c9bedd7c0f2d2aee1c2c45efddd879be13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94c727edb5d36737010b0175d5111831e52795b117881cd16986e0e691b059fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de527b54d44bc4aa1b696a23a07ff23ba4eef8ac9dedd40e2be8c11e5bdc7ecb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e60c60d822ea535965afc0cb40a8d00f5798c84f29447a5b60508f1edd8346c9"
    sha256 cellar: :any_skip_relocation, ventura:        "b74724b71bc4ea33afca1da7f52f71f86464d5e61df44202b019cd66e0f887f7"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d5d23c3ac55e1e44c37eda0f3a672a854aa4cc26a208a9d4f6baef111c6685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255eecd75b4249a59512a499596a136a4930d3fb082b66cd5d22e35f09cae32e"
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
