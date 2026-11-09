class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "ecf3d44f0a294a7e8d5e9a4203e67a1a2348380cd84d8f502aa1c436983a5e8d"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9970d6217d9a118fddeebd03fa289fca4f48c72f5f53517e6c4211b275e883b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9970d6217d9a118fddeebd03fa289fca4f48c72f5f53517e6c4211b275e883b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9970d6217d9a118fddeebd03fa289fca4f48c72f5f53517e6c4211b275e883b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd705af4782ed68ea517fedee82d085ac039efb8d7cd3e512813650bd07e822d"
    sha256 cellar: :any,                 x86_64_linux:      "950cb6bcd81e9833622220840710835f5594959c8a8e555e07f7be29732c613d"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
