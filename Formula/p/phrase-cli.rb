class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.64.0.tar.gz"
  sha256 "b929ac6efe853ff186154e8bde28f0affd64747561b7b05f11d7404db05c9c3f"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71710611147703c54d415553f8a0b03e558865328f919edbe9103d9299321672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71710611147703c54d415553f8a0b03e558865328f919edbe9103d9299321672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71710611147703c54d415553f8a0b03e558865328f919edbe9103d9299321672"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb82ee7533555d32cb4bd624af157c7cdb0919e640ee5a55d44a505ae127777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9899741a737ed2891aa0ae21a1fc3513c623c550f1ddef5ab8d427b522c8f1bb"
    sha256 cellar: :any,                 x86_64_linux:  "69ff743bab044d07f9190e3e2bfbe47d650f0dcd6769f93cb2b52c6363c4950f"
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
