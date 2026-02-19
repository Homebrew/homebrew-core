class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.55.2.tar.gz"
  sha256 "94040363584f1dc888cab4272788624d34325aee3e1f7c51b375d45e19eb35d1"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73d9aec15539006800bc81753820a5975b5d8ce57fbf36bca180b95db0842cff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d9aec15539006800bc81753820a5975b5d8ce57fbf36bca180b95db0842cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d9aec15539006800bc81753820a5975b5d8ce57fbf36bca180b95db0842cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2439e7481e76302193be813cd6ca538cf9d4be1a184b567e674aa5372b201808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d5ef87b9884fbae30589d0507b17995ad36e1788736fc5038ea130b3026b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e843ba9cd3e0582e4ac290239aae83ed2180eba10e3da0263ca94a51750709"
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
