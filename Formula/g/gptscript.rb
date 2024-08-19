class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "3dc7df2707f6655cdedda3c5fa3d5367e312a82aca681a2afe99cbd962d770ce"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3696a7cfcb92041d12725de49de8f5824c775cac622edb770b613d45019fcd73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beba6f395c3a6ae1209c2a2ff5d27e64b33f813a40603ab33acc5a45a20bc113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173bf764713beca537c6081b69cae596331c639077a51fb7e576f22e50f7ee6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "07b491fd29e4a3a51c61ccd662a227feb88c7efa33a6fd0f63c8f9feed7fa7ab"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d10ff67c37f4d3a45ead8ede7bb0a10906d87f8b07dd2a48cec215cb29448d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0b718458dd9ff27356b12097d7069398b16706d4682e1c81d64fd6a6442218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9735c3554ef023fc788eac87e210552b4c951113b2ac0f4c410e5fad8289cd2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin/"gptscript -v")

    output = shell_output(bin/"gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
