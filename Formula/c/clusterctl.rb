class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "f11b7dd5150eb38fac10de031ef4fb6c24b5d859ee2061ab4349d33875cfea08"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a889facb73dee281853baed17b6b7d61188fe102f7dd0cbf58b3803e2d86a5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e319636ec482244ba478e0ad2a795345202f0515c16998734d510b31e317f80c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42033866902695401556ba5776167cfc46642dce11a0d92bdb79c5a049b3a742"
    sha256 cellar: :any_skip_relocation, sonoma:        "43159d0c100c2f3d905cff67772c3a1a09fc57b4b40c5dfc0229f9114793393b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b4698b74215d3fdc6fc02131effb61dc3edc84b07ccdd3821397ca3f22258d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce194bf7d26a40dac251dc9d93f3bb3d4a81def30d6f440f6aa9393f1283cd5f"
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
