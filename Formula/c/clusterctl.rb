class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "6fd06b65ec1dcb03d8991852935d841e8e8c03c2d2014c7f57200b81339f1ad8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce9063529f6c4ae1499644fe80cc5f64d6599a70ed31a8751461503348e70eb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb787edb706563d91972da4d4688d5ac0072743df4ac12ccd0319e6293df814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe28c61a1ea4a00be4d79d90fe78898ea1bdcadb7e966120ac4a27971769258f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6246a72efc6439ac77e2d8a0fffd303047752f008e80e2f0d94263d57cf74026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b7ba6bd0c476bdabdef17a8ad4b7fe8de27e92bde56b9e0663fe3dae3ec68e3"
    sha256 cellar: :any,                 x86_64_linux:  "808da7cd70699c7f9832bfa2ce7a97fceea673a60089e01f20f2953f070d3be2"
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
