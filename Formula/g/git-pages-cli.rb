class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.8.1.tar.gz"
  sha256 "7c7295218e70035c490e87b4de5cff03c493cf8139291d1476bf6dbad6d7f401"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c2a0e689c64a4c359f3847e4ddc43f3a479fb8e6a09eed6f4001664ba59e1f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c2a0e689c64a4c359f3847e4ddc43f3a479fb8e6a09eed6f4001664ba59e1f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c2a0e689c64a4c359f3847e4ddc43f3a479fb8e6a09eed6f4001664ba59e1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9dc5f2e6d2e67937a58aa69bc1105d4acc68ba6fdc4d6eaa720961dc74f8289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7606c9c7db64902d960891f5acf98d0ec3a308f0b0082e39da0e732a3b8f72a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13195887ea25c4f52777b82a91982457337336cde0802270fd2407ba28530141"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionOverride=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
