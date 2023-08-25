class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.10.0.tar.gz"
  sha256 "4a3350def801f663c65dca43f180a1c3b14fccd0987691424c58079f205652fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6a6a9421f0e5d580992c7df4f65448d875d08dabc0b0e2f83e55b60efd767de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e685f89be7499cae62148fa3312aebc8743723088e72779388f9a93c3035c584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "172fd9c3a97d0f139567f163c037b30e3781ed75c7740d3b08ab1d071dcf1114"
    sha256 cellar: :any_skip_relocation, ventura:        "0a8f6c8c7a0b30230c99a6a47bb881dcda7e498830b00d65676da95f28bc0421"
    sha256 cellar: :any_skip_relocation, monterey:       "df72533b738fc10b189e89812953deb78c51003ec2eaba32162db9a1229e1f38"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcb7c153ce3934f7b827b84e0249bcba27fac25fa8e6399cff6bbbd52850a526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419fa5b9dd855edeadf551ca88c4c4841dd382d62ac65844a461369e3665d19a"
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
