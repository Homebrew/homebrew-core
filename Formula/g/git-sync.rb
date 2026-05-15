class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "a54cec1a8b30380f08cae5230783fd21a5d8ee6a0e185048d7ca80847ddde19b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33136f82f71d403ea6a970959d8ca21be7a4ab7f3a210c164ccd307b0382c80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33136f82f71d403ea6a970959d8ca21be7a4ab7f3a210c164ccd307b0382c80c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33136f82f71d403ea6a970959d8ca21be7a4ab7f3a210c164ccd307b0382c80c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8875c890add3925df8921568bde2fb11787816f6dff076ab999007aaabd30bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4815981f65fd5aee96c003f15d3ceba5a0bf71c3ff846f00bec2622a796121d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2ce5c40f72786e09684cc3d1225e182a6165e057fe5474383cf474fe174136"
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
