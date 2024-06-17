class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "66515766eec2518a9db18e8aa930bd20041cff2c73f1b5a3cbbac72eec971fda"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b21b1259ad42f537f30b15c83d6d49e249080e6cce588ce2ca46bb432569e595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b28430f9537cb82639d48b978fd351518bf7349f06e4de3a1bbe4fd99710d2eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f831cf6a5f7ab05cc19bb918ebd27e0f27121a2f91363a483ce18796159b696a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8514ba25c3225331de14aa0c5b7cbbb80551dccf45a667878779427d751a45b8"
    sha256 cellar: :any_skip_relocation, ventura:        "37268a721728637fed72d44d977791498cc6d7bcbbb181d3e73e03c1b6684b86"
    sha256 cellar: :any_skip_relocation, monterey:       "70fc6c375862f265e0dfb3492d2a8689af6b6c307b9e607d6789e55f4f6a4e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfc29bd86729756019e168f73771d3a1d2799b407fced0850f57d636ca6552cb"
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
