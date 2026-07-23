class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "e575e37581869cd31d4752f50365fc0a94c3f9f95fb70c8b2f98262776077a3c"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4e283aa56077bc853b222d9f8c3c7f7ac2ffe678d2bb6b22fcc7be159625e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e283aa56077bc853b222d9f8c3c7f7ac2ffe678d2bb6b22fcc7be159625e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4e283aa56077bc853b222d9f8c3c7f7ac2ffe678d2bb6b22fcc7be159625e1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a035af0121164e42c185c8a08ed37cb92a84623919d25edfbb7e7c20fe3d181d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ba5a9807350a7be72097c63c7c4c56d5d46e8051e211d90f71b5f30795dccb"
    sha256 cellar: :any,                 x86_64_linux:  "533b05e1e9bac73ec0f7d7fceb2ce3138cb92d8ac6fbdd9818632d1303134b64"
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
