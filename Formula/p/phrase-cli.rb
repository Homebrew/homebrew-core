class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.62.0.tar.gz"
  sha256 "0a92af0e328a0f0b23ecbb93b2b2f5a3f6179219de67fe536ec961dc5d38e424"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507ba5515d899ba98d0f11cfe0c63d8a4de4dba7cec1f7af9046c9e840759b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507ba5515d899ba98d0f11cfe0c63d8a4de4dba7cec1f7af9046c9e840759b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "507ba5515d899ba98d0f11cfe0c63d8a4de4dba7cec1f7af9046c9e840759b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab0adba972384dab942577b7ed967796bc0894b191842b4bd5b36572fcd7366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6200ba463bc85df70d0f04eaa80271550d31ac393fb8cf57d5790c5e43d91750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b6b0f4e85f72e34c19640515d663c938fc837b75bbf9e4eeb1a31f1c096c1a"
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
