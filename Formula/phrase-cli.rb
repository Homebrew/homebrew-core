class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.7.0.tar.gz"
  sha256 "8b6933d66b97e51131c4a1a8a8a80bf00b33de4e5730431574ed25735e4d4c6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "511c617d9060c96626608ea10c1ffc182ada76da8f810beecd9eb70a622e2fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511c617d9060c96626608ea10c1ffc182ada76da8f810beecd9eb70a622e2fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "511c617d9060c96626608ea10c1ffc182ada76da8f810beecd9eb70a622e2fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "dd70a36f0fc773ca3f6428b55cd1d2b409386424c84f14a254b80432322af62f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd70a36f0fc773ca3f6428b55cd1d2b409386424c84f14a254b80432322af62f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd70a36f0fc773ca3f6428b55cd1d2b409386424c84f14a254b80432322af62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac29c6b339de65c94a400879a7be8e33dc29552e973ddd1d05d53090d0b784a6"
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

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
