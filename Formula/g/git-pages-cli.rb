class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.5.1.tar.gz"
  sha256 "e4c26db1de705b3a5c9d486b5d6fbccda88db29470a4d497abfaec12b62bbcd9"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b57bf1db4a6904066cfeff95489d237ec691d5dfaa9af45cd4a5ec5623c107f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b57bf1db4a6904066cfeff95489d237ec691d5dfaa9af45cd4a5ec5623c107f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b57bf1db4a6904066cfeff95489d237ec691d5dfaa9af45cd4a5ec5623c107f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c8c8b9aa133bf138469ee799d4e040565a08b1f53285c7fbf49dab9b59733f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7184e911920c6d74d6d61b19673ad4307f5ec19c71bb94c41d93d87cba3f3256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "856e2ab8c6a471595bb45d4b0602f0419d3edc2579eb65438f518c08f2b903db"
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
