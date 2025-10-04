class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.47.0.tar.gz"
  sha256 "9531085163eb7227b39729cdc8672a21965eb96cf4fe7e3ed9aeac40b6509f35"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "285216ae8608cfde790a744c7f5c11f8a640bcefc928901d21d2b0a789a4957c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285216ae8608cfde790a744c7f5c11f8a640bcefc928901d21d2b0a789a4957c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285216ae8608cfde790a744c7f5c11f8a640bcefc928901d21d2b0a789a4957c"
    sha256 cellar: :any_skip_relocation, sonoma:        "186516c9a3310bedf7d964d4c6b915c85c9f9833151257f4dada9b2a82aa6f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a217ae87231cf87d719bd2162538f521234f580cb6c1bb279526ee572edbc8"
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
