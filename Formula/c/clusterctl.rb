class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "bba579aafa6d21d8baa2418ef44e911566db876b0a7623786bf204de96e2432d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0606ac9954a887553dc6858d54639b824d6d82b6a94ed4a5bde032d93d7ea0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0606ac9954a887553dc6858d54639b824d6d82b6a94ed4a5bde032d93d7ea0ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0606ac9954a887553dc6858d54639b824d6d82b6a94ed4a5bde032d93d7ea0ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc7e5642c9044096c26164acc3538b0abbb5f793a0334eebe860489e58e3587"
    sha256 cellar: :any_skip_relocation, ventura:       "5bc7e5642c9044096c26164acc3538b0abbb5f793a0334eebe860489e58e3587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c326ce7d17de48d82640f0cbfe73a6e5dfc7590d683945cbac891701c56471"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/cluster-api/version.gitMajor=#{version.major}
      -X sigs.k8s.io/cluster-api/version.gitMinor=#{version.minor}
      -X sigs.k8s.io/cluster-api/version.gitVersion=v#{version}
      -X sigs.k8s.io/cluster-api/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/cluster-api/version.gitTreeState=clean
      -X sigs.k8s.io/cluster-api/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clusterctl"

    generate_completions_from_executable(bin/"clusterctl", "completion")
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end
