class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "44f413ed7a65509575d757922e84479ed76c757b8fa798d71d90699c87671c60"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d3b60e0d93026d670f0a4b09aec294ffc049863a19980fed0ad34fc61fe7dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d3b60e0d93026d670f0a4b09aec294ffc049863a19980fed0ad34fc61fe7dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53d3b60e0d93026d670f0a4b09aec294ffc049863a19980fed0ad34fc61fe7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b119779af6e2e78f87b42eb0ec4954d7dea4e6f986de0124a575d26983e4bb1"
    sha256 cellar: :any_skip_relocation, ventura:       "3b119779af6e2e78f87b42eb0ec4954d7dea4e6f986de0124a575d26983e4bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3a65f67b0f54e5ae5a0eadd0234079546ff7d33250e761ec035bd6fb475552"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/cluster-api/version.gitVersion=#{version}
      -X sigs.k8s.io/cluster-api/version.gitCommit=brew
      -X sigs.k8s.io/cluster-api/version.gitTreeState=clean
      -X sigs.k8s.io/cluster-api/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clusterctl"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end
