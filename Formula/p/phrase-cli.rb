class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.55.1.tar.gz"
  sha256 "b01c0aacbba9d2228d41189faa15c25fff80fae4afecb0556c14959c546975b6"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d62f8bb4ed6f25c5bd0a62f4fe9f70a8be6536dedaf7ee9e16e1835f715911a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d62f8bb4ed6f25c5bd0a62f4fe9f70a8be6536dedaf7ee9e16e1835f715911a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d62f8bb4ed6f25c5bd0a62f4fe9f70a8be6536dedaf7ee9e16e1835f715911a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af4a97752123edd14c65e0203a9f3ca14b69fcc3587ee622783c7442364fe1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53682bef9031b6bae18bc61e903a137e099bf6538b661dda3a7cd5e2b09d4311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0410501f1e5c682cabbbdbe0641ed5616109f841a465af368617af54cc6122c6"
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
