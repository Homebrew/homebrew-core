class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "48cc2e6ec6425c030e9d10a81135a5e20ab15ec8eee0a49d35a83eda06c5cc92"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc050c14ef0a51596c4273df592c16c5d400d3e14b9094990f46029e227967b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc050c14ef0a51596c4273df592c16c5d400d3e14b9094990f46029e227967b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc050c14ef0a51596c4273df592c16c5d400d3e14b9094990f46029e227967b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ca84273cc3c87fe0ae551ac4cd981b60400e4a8205c6748484ccd3944c3bad9"
    sha256 cellar: :any_skip_relocation, ventura:       "0ca84273cc3c87fe0ae551ac4cd981b60400e4a8205c6748484ccd3944c3bad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7dcf27cef7f521453a62a5db71d452ceb23236d17679e4ae1682914df6a50d"
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
