class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "7ba41251be41f6da02a7745b715b19bcb183aa118036d04f5275955c53edc828"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82dc63b4f254fe53ea5f8187eb9c048ac2a1598a94e56081070f6e4ce02773d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0daffc55d98b6010950f33915a1c3805ef2aed4f304f966caacd1491e4caeafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f7c02dd4f74a8ee830970ceab3c2b1f961115cbcd4c826339e371164297df9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbdf683480d8846f2690c2e9dc7df75475c11b5c098691747395aad4f26dc095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333326f594c6d2ae6972c57fe8b3bef1b4dded34e6ccedf16beae6762e225085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24885402f5105e27e6ebafdef2948848dc18dec28d3f83e307ecfa9b433bf655"
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
