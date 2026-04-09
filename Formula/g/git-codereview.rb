class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "f088137cd0b92b17975efcb42fceae6c6f1726d684524a9feca77cbde2f356a8"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27333cb5b5ed60afbdd1646755630f41aef968b956efe53a4420f6dc7322f34e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27333cb5b5ed60afbdd1646755630f41aef968b956efe53a4420f6dc7322f34e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27333cb5b5ed60afbdd1646755630f41aef968b956efe53a4420f6dc7322f34e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8097d101c0d6aa77bece12d005b53e98e3c51c38437bbcc4c3bef20af8e633b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c8c96f7826982369edef0ef9c4d66eb3b285f5e19d9b80989f70d8516a45658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4b93455552050a1698d9a35aa2d0d85654a4791391d1f6556b28d213fd838a"
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
