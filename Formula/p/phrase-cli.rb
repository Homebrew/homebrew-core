class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.13.0.tar.gz"
  sha256 "b870686b5e2ce6f670bf419f053cec729615f424cfdee1124ba9e8de26c32c87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26018f6128262b9951284ce6261537dee2b9018c89d0439785ff9f9a659fd9ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8de9f8bc50f0f10f37c2728f82aac902b4a6125eb90aa1437ea5008af7d475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c186003f861984b5027c37a373d3a0079c36ab387edb612417eb13a92163c5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c64ec58c4686a946f8ac7ecca47dd78b73d81e3d5c70d11735ab278662e8d682"
    sha256 cellar: :any_skip_relocation, ventura:        "0cd0313bccd1b7668c98df3492b12ddead628e8a18e943e68b6f42016176b8da"
    sha256 cellar: :any_skip_relocation, monterey:       "118fc1657ee926a35c08181a86fbadf40486571a7beee4d6797e0613b7d659d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4856e8104b90261be7a149b0e47e859c23251feb7409813ee52917640f67d9aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
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
