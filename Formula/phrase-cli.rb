class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.0.tar.gz"
  sha256 "1c4f41c413cade1e7e0588dfa51328044944c71867d7b4b5e02cdbe91b967619"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddb0d7fb95e7a0f3847e9ca8c1b6dc64e2fd4ea70fb68f7fb369ef31e44a9e3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590ab5f27197992127643c2a54e4f25e3bd4906688fe405870f592e98252a0d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d40aad877d2bef748779bbb54e0c916c436b83f7190011651f6e5777975fbe38"
    sha256 cellar: :any_skip_relocation, monterey:       "9ded904d30ed7bf074c3569d4d9a68926622a429d66060f854b54d3d95a9b942"
    sha256 cellar: :any_skip_relocation, big_sur:        "e70969f5725a8941bb82ee9af2ea3a20296a123ead3c8b9bf323fbfc2d4d13f9"
    sha256 cellar: :any_skip_relocation, catalina:       "c04f7f0d3e5aec4679921d03240d46d7ab499b28a97077b836a32e7d9d7580e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2aa0ae52c15cf9cebec7c5ab469f468f50358d9ab8e6a0740c3a7127e0a546"
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
