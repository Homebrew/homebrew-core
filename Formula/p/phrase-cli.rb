class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.50.2.tar.gz"
  sha256 "d35773db0adee8a6bda36a8c6eb41e9f4be778cdfb7ac2898f3376735c716497"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aac807deca870f35ba9b884b705120b92265c5cc1bcfa276552dfc44617e5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aac807deca870f35ba9b884b705120b92265c5cc1bcfa276552dfc44617e5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aac807deca870f35ba9b884b705120b92265c5cc1bcfa276552dfc44617e5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f9921bd438439bf0a02efcf4c6daa717997d14459f84f1eb4534010e67e793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70e5ce1d88a338aa67b097ff8e6ac0942be21e95aa094a70ea53db3ad40ab896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fb653e8af95528bdc0bfc5bbfd1c9eec3f3f197b45254becc85f3a0a46f62c"
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
