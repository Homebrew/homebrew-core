class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.13.1/git-pages-cli-src.zip"
  sha256 "dd1dcd3ed8072d9583e50fcccad5b6e905d82d783626baf2a7987450bf9362ad"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a285624cbd053ed311c1b263b1da7575e7c60a5413f10b4ef7f8eb009111a07d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a285624cbd053ed311c1b263b1da7575e7c60a5413f10b4ef7f8eb009111a07d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a285624cbd053ed311c1b263b1da7575e7c60a5413f10b4ef7f8eb009111a07d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5eb9e965785537ecafe8a3fed08aef6296b7dc879862108f289d6e7774cf1fe4"
    sha256 cellar: :any,                 x86_64_linux:      "d85eadce39246821e4f06d774452d2aed7911bc1caeeaf822ce3f583c382687f"
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
