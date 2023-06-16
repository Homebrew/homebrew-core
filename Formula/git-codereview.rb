class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7b522916c31d012c4eb0ee2c1138f92f2692ec76f7caadd981c7fa15f237bbf4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba41cf1bce2d14066569032f369405dea19f41c6056d4af74c7a2274fd5c0f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba41cf1bce2d14066569032f369405dea19f41c6056d4af74c7a2274fd5c0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aba41cf1bce2d14066569032f369405dea19f41c6056d4af74c7a2274fd5c0f4"
    sha256 cellar: :any_skip_relocation, ventura:        "7e59a33d5cc40dc49945b5a4f4bc43fc846695b543581cf708b9cd88ffd3e5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7e59a33d5cc40dc49945b5a4f4bc43fc846695b543581cf708b9cd88ffd3e5c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e59a33d5cc40dc49945b5a4f4bc43fc846695b543581cf708b9cd88ffd3e5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44c76935c9aa027c09e6bf9c07ab0f745db04b33c27b6b43f410f81c3844de2"
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
