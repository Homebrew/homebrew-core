class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a71de773e760727a7365ba532cbf3e037a7150165eee56dca7fd7e00e89a364f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4630182b7bf20b0c34d4792bcd79438f6ed2c10538b959149acfd54c2697e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86147cca75c07b53a50f31fb4a81a2a3869d01b3c6dd3dea4880b3d02a3f0a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f30328008f464e59bacd01cba0472921cef53c436c6686b6150fbdf2e53c0b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0877651e8d549a7dfa89663f0f87fbf6e667f85a7b56cd8db0b07c0b784b9347"
    sha256 cellar: :any_skip_relocation, ventura:        "27e0524e2bba738dce3a69eade98edd9a0c28a6b75ad5b341fcee1acdb528738"
    sha256 cellar: :any_skip_relocation, monterey:       "c489df7ca037e0e8b924ad66b8419a86309eb71344a97a2214774ccf2f3b2690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f08354c9bb2d893ee6befc74a727fcc93ae32701e51d7259e88ab80c5907561"
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
