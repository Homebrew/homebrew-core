class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "0361d7c03b773b64f03650948dec1643f0a755b77445e16b849f7bda290ba4e0"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09214c67d66964c8787f72428575c013f80397af8911dad3bae9449ba441f7ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09214c67d66964c8787f72428575c013f80397af8911dad3bae9449ba441f7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09214c67d66964c8787f72428575c013f80397af8911dad3bae9449ba441f7ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b3ca7ff54882aa48cacc8135d6a974f37ee3573ca8b561f6bb653e93324e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba8d551b9f797f5b5abb72fb92ae09defab2b7527436ece64b44b03188b56036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32af71f2dc750607410e5aec7f8c3eca9555de6cf3d8b9a1dc9bfb08c1573eb1"
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
