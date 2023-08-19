class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b963c586250261a015452ded069ffcfb373db49bd1ab7165a8ceba0c4f82b40d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5590bcabb1ccdc81390d0c75889d586c147efb6825b2cbc650a4d4f17f829a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5590bcabb1ccdc81390d0c75889d586c147efb6825b2cbc650a4d4f17f829a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5590bcabb1ccdc81390d0c75889d586c147efb6825b2cbc650a4d4f17f829a4"
    sha256 cellar: :any_skip_relocation, ventura:        "59cb82fea806a3e96333aa327ab111a108f3ca2993a19b6a59b8f942c22ddd40"
    sha256 cellar: :any_skip_relocation, monterey:       "59cb82fea806a3e96333aa327ab111a108f3ca2993a19b6a59b8f942c22ddd40"
    sha256 cellar: :any_skip_relocation, big_sur:        "59cb82fea806a3e96333aa327ab111a108f3ca2993a19b6a59b8f942c22ddd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acf0cfe017ccd6fc07de83e053ad89f54169a54012f6d14f3ba2f7c34620de8e"
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
