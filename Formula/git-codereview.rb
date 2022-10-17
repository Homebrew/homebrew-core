class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3cd2fa73f99ae8806630f469c4ac90ecc27ebd2e5ee2241a1b36b1632526671d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f5ab453d7bacf9c5eeba18eae8ad7b16439f52e7f889f51733b20640be3204a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0af942b19fe91507cbe4578e7bf498227bb6d7f373ce5f7aaab442b73092897"
    sha256 cellar: :any_skip_relocation, monterey:       "5340884803d60ad763eaec05ae8ae89cfcf439ff1af1e09b53ce3b7fb22882d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "885362ec1afdf32f2f8886e35b6c75ba8cd55fd304988f047fc4bf06a8dd4720"
    sha256 cellar: :any_skip_relocation, catalina:       "42a93d8109e0cb7713b4fb46526bf89cf3a6a9a1803c2dcb1af344e730d0c678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2424c58b54caf81d5efa611dd5e4ef09a510b7d159ab8ddfb386bf9385a96f3"
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
