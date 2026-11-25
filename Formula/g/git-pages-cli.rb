class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.13.2/git-pages-cli-src.zip"
  sha256 "6ba8080813de5cc97768cd432badbb809ef845990e1b24c9263cc2797623e88f"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    manifest_sha256 "942d3d9897a732e68fe79f7c723e83f21ca37096d283e0c3518f9b4debf54f1b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06aea68288188fe87832ff9ddeeb3c7cffb902b9d35ade290f849c1cfecbedef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06aea68288188fe87832ff9ddeeb3c7cffb902b9d35ade290f849c1cfecbedef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06aea68288188fe87832ff9ddeeb3c7cffb902b9d35ade290f849c1cfecbedef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c69fd901b7af5c71c95fbc88759bafa3ee0c8078595f9115cac29a861952846c"
    sha256 cellar: :any,                 x86_64_linux:      "c0a15915730be466839edbb2fd6d23d83e3f342fc1a45517d3cf6ceed248e078"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
