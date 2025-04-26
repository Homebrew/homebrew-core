class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2a5d98c4c1502d2b001342ddc08a35f332b4f2faf1e9f448db72027dc3d11a13"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e13e27543bdddb8fc731c72dedeb97dbab3e478fba19faaa87db91585e40234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e13e27543bdddb8fc731c72dedeb97dbab3e478fba19faaa87db91585e40234"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e13e27543bdddb8fc731c72dedeb97dbab3e478fba19faaa87db91585e40234"
    sha256 cellar: :any_skip_relocation, sonoma:        "b366fa9753f3d00b1bf0ab13c92dca610b80307c9062e72cf5b916deb2a73a0a"
    sha256 cellar: :any_skip_relocation, ventura:       "b366fa9753f3d00b1bf0ab13c92dca610b80307c9062e72cf5b916deb2a73a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca3bcf0efe80a59517ae0dc8ea8e3536aa97a157eb88a74efea591468899fe6"
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
