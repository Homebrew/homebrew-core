class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c638561c0f173434576fabb55c7783359b0b09e1ab4984d9eb78555c043543b3"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c6be78b066a0d79f7558e37ffcd68151001fa57a9591096abbba399e97e770b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596e7b7b6dde1d01bbcf7ed1de30a1e094262ac32726972dc557d6c0937bdc67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e851492a2469a86264b73ebe0344477c8ac079f279b6e8984deadf85cb508d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c794c69aeb820b55b0927d9a6490e86efb7cee4664012e5e977fbb05dba0ec14"
    sha256 cellar: :any_skip_relocation, ventura:        "04a91a9c2c0173c02bee2c50ae975f2ffc63c93260217086009b22aceb4c6c7e"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec03f6b44425fa2800c69e382c1a492a6fd9b61fc26b8192b298a7e3bf833cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3e337531c0d38d22b184ad45ccd39ad89c7f2f98852391185414c437047239"
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
