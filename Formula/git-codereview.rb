class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3cd2fa73f99ae8806630f469c4ac90ecc27ebd2e5ee2241a1b36b1632526671d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a022cf724cf39fd6dc92cad7a55446a9f0302c845ef87e03f46210dcf199988e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fd65180b6856bee67ae21817cbf2a726fe7c1d35bd3002918db11b1202130e4"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3cee8c351d10e662060dd4fb2cfac24e2de656afbb03650ef0a1fa8c9052f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf79d08c1c6707b3694dc4160432fc6edea8b76a9093c6644613b7d2a8c14833"
    sha256 cellar: :any_skip_relocation, catalina:       "c7b20e3b59d51981043502b8d5269708b7da52d671495c93504945422f601a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95eb854057332df92b876d9d779b6131f53d2dba28ccf7bad1a08fa48d2f47ce"
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
