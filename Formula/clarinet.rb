class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.23.0",
      revision: "58bf1f54ff741ea28039c7868527c6e0561e18ed"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093261672d5c188d1d17ca808f08396432c158ca74b851e233be9bc18dcb921a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1b2a0d3d80a11b74199e86e7538063d20a7b2eff880117f96783386df59974"
    sha256 cellar: :any_skip_relocation, monterey:       "52949bbbc90e8495046fe64f0f31db34a141fc7427884c758f708abed806efbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f6678f1a0c87024d97232522b552a54bc7d258e60fa0bbbd0ad000ec39b885b"
    sha256 cellar: :any_skip_relocation, catalina:       "ef44ea054c8c057fc230adc6f5df27534abfd519ffea563170a48995708e7aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395f02e9019d9e12ed59b15b025c9a324e850e5ca991a7113440d717921ec3d0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
