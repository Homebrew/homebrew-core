class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f5f368c4a83dc965d83d41d54ed13a18e27e2323acb652f50550976e78721f5e"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db37e433af1e6733b4afa526443a8815b00c6ae100d56a205eb711c810af7e66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db37e433af1e6733b4afa526443a8815b00c6ae100d56a205eb711c810af7e66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db37e433af1e6733b4afa526443a8815b00c6ae100d56a205eb711c810af7e66"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd60cc3eb8564d22f753e1e7a969a951fdfd63198d526eb52b218e256d5f0d59"
    sha256 cellar: :any_skip_relocation, ventura:       "fd60cc3eb8564d22f753e1e7a969a951fdfd63198d526eb52b218e256d5f0d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0684f58107b420e83ad3754ffd196af9f4535a294369615448f4ade23f907192"
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
