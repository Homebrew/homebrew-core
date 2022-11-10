class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.4.tar.gz"
  sha256 "09875a3307ffade3a2a139a9c35cbafeedaf5775d899fe44ba747d945c4d4c8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c766b689bcdd75ff95066e448f271adb42b312728c8fc8949497c52cc23be51b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56bfe84ee33baedaa615003c5a727aaed1d9701e3fb4b22d0b87d8260aaf3224"
    sha256 cellar: :any_skip_relocation, monterey:       "bd5f790c9b0049cfafc87b9750a7eeffe719b4e7c43214505a03e617d2a225b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bbff560841349f84aad00aec1da0cb616f173bb373bc7205dc5aea26f30af9"
    sha256 cellar: :any_skip_relocation, catalina:       "7a43be05662fa64ada6be017815285b0a83d5db3fd61b67fb5a89ffcc4965a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44d56a3df7c1a5547c4e5c9168b11a7a9b1abc43f8f965ffe3f2a46ec2acc8a"
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
