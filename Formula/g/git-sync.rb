class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.8.1.tar.gz"
  sha256 "a7fb384fcc826fa0f4f1ef47004ad00ed66eb8814d4656e8b73b90534ebc629b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    manifest_sha256 "f5df8692f25b3d527475ca486f42eb711b15cc222def1350b04457db9c4a55ea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11e22b50f2334955905359b4d13865fb9e2eaafbddb98d60f91dd4bce64ab4dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11e22b50f2334955905359b4d13865fb9e2eaafbddb98d60f91dd4bce64ab4dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11e22b50f2334955905359b4d13865fb9e2eaafbddb98d60f91dd4bce64ab4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05cbc76471d632474d01af17923819c7e964f00fc4cc0c7be402bbd065817345"
    sha256 cellar: :any,                 x86_64_linux:      "160bdb3e1855e097ff3208c3ed9797c2d6b63314b19314f1548f731ea61d5842"
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
