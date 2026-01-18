class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.53.2.tar.gz"
  sha256 "da1c1d00493cfdc440d678ad21d77a97ca4f7419bf0a66a4bf69415acb74f23c"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0592c9e9dd7f16e6ba87adf57896775605aa3767df6f2b4ddbecdb8498d44c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0592c9e9dd7f16e6ba87adf57896775605aa3767df6f2b4ddbecdb8498d44c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0592c9e9dd7f16e6ba87adf57896775605aa3767df6f2b4ddbecdb8498d44c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "171039c4b87d819fe8e72be0464b1a690e67ddcb641e5ae5ebe90162d675cbbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d68f91506b3c99b21207a4121efebf92f59cfe7baea77ca30109ce0c76935d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eefe9261b10aedbb8eae7b3f5a9a180729e5ff13cc3f6fb20e71c0d4e5d81635"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
