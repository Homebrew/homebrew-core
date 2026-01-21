class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "451c5f6d27d048a1fe3afc3341686eae973a5bc1883f4a4089ba74e16117cfc2"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82223a336cdd2844666ecc14ce6001d10559ac55028fd8830c009a59a0fda152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82223a336cdd2844666ecc14ce6001d10559ac55028fd8830c009a59a0fda152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82223a336cdd2844666ecc14ce6001d10559ac55028fd8830c009a59a0fda152"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b414962926c2c602e3d191d3d5c9f0d4a515db7865425206c12f8aa63a877e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa8d0aae7c8d102e107720d41c050ae50c119aca5b8acfedaf46b501690038d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af2a9619e06f758cae51509808adc11cae17b9cb652db00f3b99905eee5d1fbe"
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
