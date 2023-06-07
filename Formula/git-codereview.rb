class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2151eb3ea0a288b7f65489b8bbc835d2ee52e38d202171aa9a183ff53664e7f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d871c76cacb3e51e6ee8a6a4b39a72e9310f30fb4d209c35869a1e57a150c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a26e63910368689c89fce6ba378015b1297c9754d162a54f78a72c4a4bb02c48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcc7c397e87a946fb354d0c065c1430ba9e8b8792e5c2769618b274ce12f4175"
    sha256 cellar: :any_skip_relocation, ventura:        "615adcf9b8896d07d49191f3b8dadbf8e8baaf13dc0e28d5901a38a20742bdba"
    sha256 cellar: :any_skip_relocation, monterey:       "91fa742403c824968b9e11d00debc5ef0b0bed384508bab73de20f215f0743b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae39a49342826e3eeb963634bd20de64decadca88c606d757c4720b3f7547dd4"
    sha256 cellar: :any_skip_relocation, catalina:       "d73b438d666c2d5d5287610ff8902b9123de533d32b14784a827f820f5341d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f7ddd3847c074a39c133fffaa3ed7607b0fdfbbad854bfc2ee78a8084161a3"
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
