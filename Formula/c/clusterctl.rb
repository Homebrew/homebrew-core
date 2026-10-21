class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "656214da5b8a773303512d49edcb4d0760672d8d71b2be3f3bc36e31b0919c49"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5acf764e08379a0575f9b10e60950704b356382023644215665ea90217df2d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a340180f0483a6c6fa0733e39e4b50be6cb05e6d4f283db13b6ba7e72bf3bcaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd6e04196bab561948d42e860369fa142eb2ef6b8b25739d68cb8c07dcd9c127"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2904c1b873e20a9642a33a41b9381a8a8d4e6fed7fa46a78506ea8476d3046d8"
    sha256 cellar: :any,                 x86_64_linux:      "23407ef5f6e995398fb01dcfaebad3f82a0b7643279e06908dc8b8763482c20a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
