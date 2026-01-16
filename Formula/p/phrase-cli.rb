class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.53.1.tar.gz"
  sha256 "c53c9643fb5320bc9df1e27f8fd4c4d9c11c741bb663db7e64dca16df23981f1"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514c5f41ae48a6507a4027329fd8f638c81099fc0dcca4556fa48c2666242b49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "514c5f41ae48a6507a4027329fd8f638c81099fc0dcca4556fa48c2666242b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "514c5f41ae48a6507a4027329fd8f638c81099fc0dcca4556fa48c2666242b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35c57f6a2781819e2917403f9d1f867024e24700c31da4219a2d4d9af3eb524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e112b0baaa98c6e4b0c6601750f4e38aed7cb46fbcf4ce79117965605ec8a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06775e82a03faefda80472e2cee122b82ceaf7a9011cfb9c5422ca2c85347c01"
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
