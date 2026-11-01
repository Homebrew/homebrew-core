class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.13.0/git-pages-cli-src.zip"
  sha256 "79978453573b302afec1a5834dc96c1d6d132ff57574f602caf2e483bc698eb4"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "708fd5c316bf0480d8e60188cc6e3e6423319226d04eb25e37692215fc00f5e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "708fd5c316bf0480d8e60188cc6e3e6423319226d04eb25e37692215fc00f5e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "708fd5c316bf0480d8e60188cc6e3e6423319226d04eb25e37692215fc00f5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb9deafc374994969cb2cf05431366e09b9aec5459458cc6c18e10e652c3ff77"
    sha256 cellar: :any,                 x86_64_linux:      "97c52a44d306a576089353b9e855420fee45861272c250b5712e9ad3ed8d7a41"
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
