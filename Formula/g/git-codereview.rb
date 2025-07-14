class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "7e9d47d8025f1569c0a53c6030602e6eb049818d25c5fd0cad777efd21eeca20"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "141f8fec07cc5476f969bfad9d545a8a68860402807f3e58edbe9d0b2d088d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141f8fec07cc5476f969bfad9d545a8a68860402807f3e58edbe9d0b2d088d65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "141f8fec07cc5476f969bfad9d545a8a68860402807f3e58edbe9d0b2d088d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae2d74d81b3af07481fcc7532c8a682a797b4cc8631b1f84cc9a9b25f44dcb47"
    sha256 cellar: :any_skip_relocation, ventura:       "ae2d74d81b3af07481fcc7532c8a682a797b4cc8631b1f84cc9a9b25f44dcb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd88be0c3888dc913d4161a346af8e7852b4e01eb3319b6231326ae166169d11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
