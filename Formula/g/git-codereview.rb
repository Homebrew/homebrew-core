class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "e173b12004b813dd2bab7c2cfa3d7a26433684f4dde2e23fcba2bc2a52151d11"
  license "BSD-3-Clause"
  head "https://github.com/golang/review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd553d8c7d4d86e0eaf4619141954804677f7622c0f6f2503e60cf25dea3d652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd553d8c7d4d86e0eaf4619141954804677f7622c0f6f2503e60cf25dea3d652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd553d8c7d4d86e0eaf4619141954804677f7622c0f6f2503e60cf25dea3d652"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd553d8c7d4d86e0eaf4619141954804677f7622c0f6f2503e60cf25dea3d652"
    sha256 cellar: :any_skip_relocation, sonoma:        "adaa7bbeaa229379796a8f873769089a99801a8f7e896123da5b128bf90bb093"
    sha256 cellar: :any_skip_relocation, ventura:       "adaa7bbeaa229379796a8f873769089a99801a8f7e896123da5b128bf90bb093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91241c3fab159b0ea0d6b4b4284260b4a09dd271b8db9a750225180c8e83743c"
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
