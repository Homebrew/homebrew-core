class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.46.0.tar.gz"
  sha256 "407ae4113852e949ab7418d515879bfd71beec58739a01355f6c631fa0dcb1c7"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9852fd561d87376838c75b1b002e6013a4ee28b82a02a3f7dfda9d5af7f350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9852fd561d87376838c75b1b002e6013a4ee28b82a02a3f7dfda9d5af7f350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9852fd561d87376838c75b1b002e6013a4ee28b82a02a3f7dfda9d5af7f350"
    sha256 cellar: :any_skip_relocation, sonoma:        "57212e1d415e5b2918fe2f35f82eee41c9f5fcead692a52f878193eb175fa65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a58a9b97b89b2594bc473dd072421ca68244ba449abcdbfa5ac414e51f89af"
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
