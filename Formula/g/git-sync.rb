class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "8c6bee1f131434546e6202fe544ebc116b3227ed3af4ab75eee15337c209b308"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e0a1317eb9127f6a60b678ad9723261ba3f18c792eab45c267a824c7575d7cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e0a1317eb9127f6a60b678ad9723261ba3f18c792eab45c267a824c7575d7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e0a1317eb9127f6a60b678ad9723261ba3f18c792eab45c267a824c7575d7cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af1656f1d074d57ebd2ce5a0be9cd779035359283601b0e87ceaa3752a656327"
    sha256 cellar: :any,                 x86_64_linux:      "4ea9224f87f5aabcebc4c8d62adb4044212df12acea85583f1df3a6697e32170"
  end

  depends_on "go" => :build

  depends_on "coreutils"
  depends_on "git" # needs `git config list` (git 2.46+)

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X k8s.io/git-sync/pkg/version.VERSION=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
