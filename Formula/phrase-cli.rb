class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.0.tar.gz"
  sha256 "1c4f41c413cade1e7e0588dfa51328044944c71867d7b4b5e02cdbe91b967619"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a8379545dc9e8ee009d1c23b1f7097bfcaad33494ea291a94a4a8676e61ab19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce951734ebfc956a9968b2d315d0f3ceb74de9263efd883831242b1adbdcb2c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3947d6edb89678c3dc59144be1cdcfb308f18a4882c3a9aef84501b2c6e077f"
    sha256 cellar: :any_skip_relocation, monterey:       "2099e8c776ba891dfe1ee9d665ceeebb9584e07cdda41ec13dbe323485533a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8bd0432edea67cf891861dc1295bbf0bb9ad5c2cd6d62c3b68b39c2589a619"
    sha256 cellar: :any_skip_relocation, catalina:       "8c7a31deee2ef22bb5051a741596ae4dd6de78999e3d8efd0396cf599e17eb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf1f0aeddaa18fa436e5776479f75853eb12c729e2a4f610d9d0b5a096689c4"
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
