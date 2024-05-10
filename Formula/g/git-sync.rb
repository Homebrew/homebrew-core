class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "5f64a9110ffbc4741c8b1f89882bb0a4da95074980871fe9ab00d49b70b8f5d0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd0454861d9e9ca33b6cb16f444eac6814255f0d71c834f9c0b31f7417277b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "240082c5dae135296b4aa5d51ad639295d62e3026ff35a0d52bbb26b649e8b77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9689d917fca9c536d7f5d3eeb1e8777458553243a7c4f785c0edd6568b03131b"
    sha256 cellar: :any_skip_relocation, sonoma:         "365047216b03bba13e1d8045dd0ba902f636b8fee4872ce3ecac73e8298cee61"
    sha256 cellar: :any_skip_relocation, ventura:        "ba47ce8e4e776851e90d4cf2ba51b56a4bafd63dbc6b6370b529cc75d1e71e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "593f20f7fffe7987cebd9aab65102c826c30583a1f696df6ada290fd31a77522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8032be872054b05fdcfe8e7a0e6ffaaf2e40b8b6caa513fd19f52b48bebcb1"
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
