class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.3.tar.gz"
  sha256 "d4054e280eb9ea47843f2e909c1e38d3680d803da3fffa99c202fb7828540de6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5743dca89050c44278f88c743b8d57f557dbed4401f9e0f7dcd4e50f826caa3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d12b041d9488b07714cb4cdb95d01e36227953b3fcbe79956ee4c530dd4e79d"
    sha256 cellar: :any_skip_relocation, monterey:       "40d12152f492194d41d4eaae6d8637fa6704ff6732d7bc8ba9f2bf884899bd4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "44c30d2fd78dd54a1f048550b9635e202f5ae5b0d7d7d640cf3b8d68290b0558"
    sha256 cellar: :any_skip_relocation, catalina:       "490a54b1a8fb312d77f7b209ff052131f358f28126b5fc4d46cd5e0fbb22f939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3bb8522a6784a13132512a218b8567b02491aa988a9ff2255617baede5e9cac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
