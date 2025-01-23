class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e67f223353f191aca75e8e2af713febd07adf596a1718a03276fbc6bab3db746"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55a17bd974981216ca94abf561db3213925bb552561363fd50d0085ea4b65747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a17bd974981216ca94abf561db3213925bb552561363fd50d0085ea4b65747"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55a17bd974981216ca94abf561db3213925bb552561363fd50d0085ea4b65747"
    sha256 cellar: :any_skip_relocation, sonoma:        "c078cedf877a871f99cc3c09386207021a746d897617245b501a575fe0459a70"
    sha256 cellar: :any_skip_relocation, ventura:       "c078cedf877a871f99cc3c09386207021a746d897617245b501a575fe0459a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a02745b397413f2566aa8100a23438af7a0f5c3a0c43eb2cab622fae65eb5a"
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
