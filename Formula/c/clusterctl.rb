class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "d93fcf18606addfdd93722b197138c992022180183d5420007a4c7e5d0ccc17d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e96865bd21f4f6715c52e65dce81e8fbd1a3ce12a9e93c281a792b5e61cdc97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e96865bd21f4f6715c52e65dce81e8fbd1a3ce12a9e93c281a792b5e61cdc97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e96865bd21f4f6715c52e65dce81e8fbd1a3ce12a9e93c281a792b5e61cdc97"
    sha256 cellar: :any_skip_relocation, sonoma:        "a548789c37b4a5c5fa404323de3b259699e8a7a8f24cf1cb84dc3c664185924c"
    sha256 cellar: :any_skip_relocation, ventura:       "a548789c37b4a5c5fa404323de3b259699e8a7a8f24cf1cb84dc3c664185924c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8a9865a878248538246304a40418b40726731ab47635ec8cf86c6992341aba"
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
