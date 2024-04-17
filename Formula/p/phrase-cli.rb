class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.23.2.tar.gz"
  sha256 "2eca57d7c1f2ca89162b335ecbbca7c56f1174025b54555ce3b8bfe9d5e426f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2911ccde175484f281a1ea5b175776e459ceeca1b6f0b901473c521ab0f2969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ac13253ecd43b4da81fab7b90ad7522997001ced23b125c7a790bdb10b3e034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2dd81da18f0ba0d4c30f084544c116f119e80ea98b4cb6ec40eb0aba5d4ae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f388913bdb922024a91f8bbc12f3e6397f8bc2d88790d0607b930973fb85b9a3"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1306361239e00a7606ce3882ce55bc0fe5903252df520f55056035a35065ff"
    sha256 cellar: :any_skip_relocation, monterey:       "c81e37930d9ac62e15772d27eb2b1af39187aed82d80d3328591feb6eb1c7e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9292a44d83f8722c3e020ab9cf273a7b363a45ab32a90ab8506f26e53d3abd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
