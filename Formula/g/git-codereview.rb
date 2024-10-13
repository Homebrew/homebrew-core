class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "a95ad224bbe6accb01f33e7fcfdd5ed3249feb8580250ac3aff7599aca42ceae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6fed4521d80560afde9cd492a55e4d398c935289bd468bb3bbec576265b6c994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b169e8d6053fbd2851abb6ce30bb55c20e730e8fb7744b100244c02e7e082d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bb9ce653a4578f472a176f83bff2f9f3fbabe58f0257af8732a05d7854f3534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8982582c3a093542f6f262dd7babf8aa4d2648e2a8fd85b5b62db161ec3f0061"
    sha256 cellar: :any_skip_relocation, sonoma:         "c766b5c7e9a6871893f74c59f6f10556ab09f5129ce6463a2a68ada02fded386"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe23bb2b1c38c6e1b13581b5f2d8950f2598d1a7e50c220a4293c9ddeaf6ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "012dba31c321c6081eafb69d134f60b9cfeabda9bf7f11c2db5c3b3bd5c3c276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8e0a2ecdfbfe13ebf3a03bbf5bffdfe64b6d3411b35f5aeb960f4ee767f75f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
