class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "9006295223336d73b28b24a31f8c8210dcf3aba05dc2b57dcfbb6c71b0e03e7a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9ddbf26aa397e13d35a74f670be4a6a8baa45e0327d792e317089cd5d1fa6aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ddbf26aa397e13d35a74f670be4a6a8baa45e0327d792e317089cd5d1fa6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9ddbf26aa397e13d35a74f670be4a6a8baa45e0327d792e317089cd5d1fa6aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "71426ec7dcfd322fcba1faa5bcd3313a6811f960e8139096356161518f2642b8"
    sha256 cellar: :any_skip_relocation, ventura:       "71426ec7dcfd322fcba1faa5bcd3313a6811f960e8139096356161518f2642b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203010958b88cc2d53e57e5244cbfae01ca95ff64cead486b2181448fcc6b3da"
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
