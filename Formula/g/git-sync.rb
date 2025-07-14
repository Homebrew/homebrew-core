class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "62878584e4766b4cc94a9a7d49fe9c8c24dfcee69b4c83ece1bb1e1790b7f450"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5554166349ab5111d40364a9d1af15b6db41e0db28ec1c30a324977dc2010c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "00358f17adf3bb83339129bef02f7031c9e1c2a64f043148baf0e329ebe1d6e5"
    sha256 cellar: :any_skip_relocation, ventura:       "00358f17adf3bb83339129bef02f7031c9e1c2a64f043148baf0e329ebe1d6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2802fa19c03b602a9988b64d7339d1046a03548359fd9f92f17f5247912f3d1a"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
