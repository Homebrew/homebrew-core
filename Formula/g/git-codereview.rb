class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "d1215854ba15b8f7d457bb00637f8f137f775004e5a6568dab82d27755dbd587"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0804eb0f0eb35fe66cf5273317ec63d2a98212945990f4bd7da941fd39cde2c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0804eb0f0eb35fe66cf5273317ec63d2a98212945990f4bd7da941fd39cde2c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0804eb0f0eb35fe66cf5273317ec63d2a98212945990f4bd7da941fd39cde2c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0804eb0f0eb35fe66cf5273317ec63d2a98212945990f4bd7da941fd39cde2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9865779222a2ed0c911c9cd3a99f4e9569fbd70b136b239e21781e6c8af5721"
    sha256 cellar: :any,                 x86_64_linux:      "4d5d5bd8941f90eff4c4ef3ec2cf6102a40689e2e6f3dd4b7eb67886254f3d71"
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
