class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "123627df6935e864da28bdb3bcff9cf1f1bab97af0031eb96b1fe3e48ad6cbd1"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dd9424c0845bb1e6d7148e1ef9f5093732f8d10066274628a316a574f7804e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd9424c0845bb1e6d7148e1ef9f5093732f8d10066274628a316a574f7804e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dd9424c0845bb1e6d7148e1ef9f5093732f8d10066274628a316a574f7804e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5c1e5f8a8772561f20baf22174752682ae4e7d99a75662befc9cc5a2a4c49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6742f5e0278cdc8af29082d0a8692dae6b635c3f9771e206f31638672febcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b572e6d5e16005552a5a38bc396366c966924735fb787f926e9b98aa781ae255"
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
