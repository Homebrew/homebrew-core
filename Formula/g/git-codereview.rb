class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "0a8d3ce0124e5bbf394607723a42942b9af91aaa7c03e0037c26bd462519a3b1"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44771d7e045d4d01e2074dcd75e123b79f547d16965eea79349c85ee297e029a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b506403ad1d7da51685259f4ad23b3b0c14b8bfb070608491bbb219e916b512d"
    sha256 cellar: :any_skip_relocation, ventura:       "b506403ad1d7da51685259f4ad23b3b0c14b8bfb070608491bbb219e916b512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f702035fa2d158f94eeec851b805a10e0ec75289cacd5da67fb641202c5a14"
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
