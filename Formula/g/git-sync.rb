class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "64b585b6c40446a7715c654d512ba3912b6a6669c3e93a5ea7e5cfe9f960b217"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85fbd08417109e801b8a4121d97358cb70b0b8bf468bfa6f59edbf370a72d277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f375c3fe11ec7c9eee58dd579cfa068df87310abac85595247462d11d73c356"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b830e03c0d5cdbdd0f42cd526ff4d62fd11b6cd064c8e941ccb1201135c010e6"
    sha256 cellar: :any_skip_relocation, ventura:        "a222bc10bc075b4521ddf811a574f6b4139ba1b2c6876866b07873288a4f83d0"
    sha256 cellar: :any_skip_relocation, monterey:       "bb57ad2ff9ca5876a0afb4922440a69b49edbc2556eb1aa5bf28369e6728b947"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dcdb0489499b8e39aa000484518a9efc03592dd0c33e02a4bd0463cfce5499d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea565ef9e2b43ebb1d67f921b29ce8afbb8b75cbf226caefedd7c99d5c8ad40a"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
