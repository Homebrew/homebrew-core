class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.3.tar.gz"
  sha256 "d4054e280eb9ea47843f2e909c1e38d3680d803da3fffa99c202fb7828540de6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19b2cc75c3fe8e5b0dd5dc716bff438c7f5e3a034e8467a97b32dfcdcaf7410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba97575268b660aaaca397a03835098393654dedd4114c842a2253bb9987810c"
    sha256 cellar: :any_skip_relocation, monterey:       "c311ac2aa012c9774593e32f30d825348a4cbf9ade812283cba03f160a978e1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "36b4a61211e6d8180d80b0efce914d98f0d51ffe8765798e33d750958334db46"
    sha256 cellar: :any_skip_relocation, catalina:       "4f66f1daf333f02e78c9c575d15007f74f62a4c025fb2f066ee69139147511b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aab74c5cfb3789807e037ef6044f1b3dec0586fbbd926f86c297fba1b3cfee41"
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
