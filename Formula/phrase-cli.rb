class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/cli"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.4.11.tar.gz"
  sha256 "5d5eeff5df6b44633f6119d0896bae0d79318d79d9bbe6bc80573d112385866e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89c0be7a02da1da1426d04d0c2885f99cdecdb46983c13562c7971e10923e4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9c0eda8752a03674dee590cec7ece35f6186fd8464ba97542f24d546c172acb"
    sha256 cellar: :any_skip_relocation, monterey:       "4b714a36b2a88df58963b3043170e6b8820cc8f5b23391f6bbd1e41f593c251b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5021108dd9a18820a7223f724d6543f6bf9fe4d63379750d42e7ceb77a8b71e"
    sha256 cellar: :any_skip_relocation, catalina:       "0f09e584079d249306a9961b0bae3433c2c38fdc431b5b5b0836d17cc0a7e032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832e3f50ad9931bfb8edcceeb6ed0834dd5c00bff25b8e57622538e2cdbb5f99"
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
