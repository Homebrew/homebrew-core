class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.6",
      revision: "2a4a7a47ebc3f8e3bfa97e22d300a64fc6247a37"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1741fcb37703fbb31d407fb0a4eb35d32887ff00ef5870ce66f7c9b9fe767384"
    sha256 cellar: :any_skip_relocation, big_sur:       "257553bb3ee89b4b5b2c9a1afae3ef9a44f3c9c080dc64a5b3eb9a6d5b428ebe"
    sha256 cellar: :any_skip_relocation, catalina:      "603685447d15afa041674ef58c0695f4f39d475164ccf64c2b93f1bd95aab4a8"
    sha256 cellar: :any_skip_relocation, mojave:        "32fda21995c1d951e28b199836b868682d284d7bd27138220f3d5990c524d092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8070dbeb4fd1f7ee7a78cef4f0642c8bc4f0000e7e02bd94993934f99eddc0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"fleet"
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
