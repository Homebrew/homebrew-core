class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8dfa7dcf6a2c3eb88e14bd65144013b7070e6618f29e2969a7a6b601a5a667c4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5ec2483cd3abb51ec5b8e61409f80cf8da50dcc0159d1546c2502edb775efdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d13df1e270e070d2f616c91e15ce99981827b2305620dd5a373643b95f45e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "516bcbe95baf23cbbb19b8a0c90408285d3f3762843af072f9b00e45fbf5959d"
    sha256 cellar: :any_skip_relocation, ventura:        "d0ff896d5479f0b3469a1f58a2de544ed233e3aee394f6fb0ec504ad02d7bd38"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b916938af99e1ab6e8039cdd9ccd5042548f110948040bb0adb058dc113b37"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa7ceb4af8250465a4378b5c5d6f7df8c693aeff0ea62465f41cfe82f70c80b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224581b73f4125e3386fbf76df00471e86071fd8d3e69b86f59242116513c18c"
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
