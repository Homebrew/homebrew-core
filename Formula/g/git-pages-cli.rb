class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.13.0/git-pages-cli-src.zip"
  sha256 "79978453573b302afec1a5834dc96c1d6d132ff57574f602caf2e483bc698eb4"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57cc92b397207ee5c5f7557fb71478ea4aea195ecacbffe37fdae15efbf5af00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57cc92b397207ee5c5f7557fb71478ea4aea195ecacbffe37fdae15efbf5af00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57cc92b397207ee5c5f7557fb71478ea4aea195ecacbffe37fdae15efbf5af00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "273c68c9dc996a1ef2094359e07eec520bc2244f65d33450192ecf22f6b1ff66"
    sha256 cellar: :any,                 x86_64_linux:      "dda238b8208e3e74cf026eeb6bbac6f75d64fa5ffe873bdedcd7115dfe91ed41"
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
