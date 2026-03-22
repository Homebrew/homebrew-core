class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "13666d4cce007c3da8c1a9afdd6ffa0ae9d584aaa5ca57597caf71c5008d490c"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98967124df84610751260f4f03fa7fee00a941da36856e3ffb8e20e41726d232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98967124df84610751260f4f03fa7fee00a941da36856e3ffb8e20e41726d232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98967124df84610751260f4f03fa7fee00a941da36856e3ffb8e20e41726d232"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc40388c1dbb5e75e5270e56fb52a91972345b29499c6a101480b7f4fc6a6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0563f0afa41010c31bab0afa7be1c030e92f341851a44c04c16bb7d327e0109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251b0b4896122432f75e7402bb84e136999962195563ca19e0d4cf05e5103dc4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", shell_parameter_format: :cobra)
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output("#{bin}/gptscript -v")

    output = shell_output("#{bin}/gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
