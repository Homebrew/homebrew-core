class AtomgitCli < Formula
  desc "Command-line interface for AtomGit"
  homepage "https://atomgit.com/hust-open-atom-club/atomgit-cli"
  url "https://raw.atomgit.com/hust-open-atom-club/atomgit-cli/archive/refs/heads/v0.7.2.tar.gz"
  sha256 "100a177997c7c6199f9d8633fe4cebc5ec6d974a807e1c5318d2634ba14c008b"
  license "MulanPSL-2.0"
  head "https://atomgit.com/hust-open-atom-club/atomgit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13da2eae0487d94cb19cc868f7b5cc998ee9e5ca23863aae81bb85494d224451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13da2eae0487d94cb19cc868f7b5cc998ee9e5ca23863aae81bb85494d224451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13da2eae0487d94cb19cc868f7b5cc998ee9e5ca23863aae81bb85494d224451"
    sha256 cellar: :any_skip_relocation, sonoma:        "8597bf71cefdadb8bece472d08eaf62084a029c6741d8e7f8fcb880094f5edc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f8e97acf9b2475efaa25f28fde5fc2566ea3184b74a58b10fd7034bf4a5f82"
    sha256 cellar: :any,                 x86_64_linux:  "c712d0fa0b5d3f059eba66708e3dfa44ec08d4da8eb101d929473b95d2df1bef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Version=#{version}
      -X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Source=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ag"), "./cmd/ag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ag version")

    system bin/"ag", "alias", "set", "rv", "repo", "view"
    aliases = shell_output("#{bin}/ag alias list")
    assert_match "rv", aliases
    assert_match "repo view", aliases
  end
end
