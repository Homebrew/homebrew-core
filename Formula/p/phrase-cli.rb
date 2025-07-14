class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.42.2.tar.gz"
  sha256 "ebde8a35d4482257d5c3d198c58567e2e030c20d15491c5bc0016a50b7848e1d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3841fcb3704576f427544ce993ab92f0da7bbb3442d42ac6fa1fd7cad3ad4f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3841fcb3704576f427544ce993ab92f0da7bbb3442d42ac6fa1fd7cad3ad4f31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3841fcb3704576f427544ce993ab92f0da7bbb3442d42ac6fa1fd7cad3ad4f31"
    sha256 cellar: :any_skip_relocation, sonoma:        "8315288852b46a27160369244c0881df54bcb3728f5194ef31ae770dfdba5cbe"
    sha256 cellar: :any_skip_relocation, ventura:       "8315288852b46a27160369244c0881df54bcb3728f5194ef31ae770dfdba5cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e39ca34a413044143335c2620dda512609cb790c303ad3f596abc33bbf9cf18"
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
