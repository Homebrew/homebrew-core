class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d76e1026b3d8bce474fe75fa92a912216cacaf83d65a66e7a8f96ea81a9bbad6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5e88b44dc5a5cec0b0617cb06d6e1659c0c0838617e0c5db11b20a676391826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44003338581d6daf0134afbcd7f819cb3ff06b52cc1efcffd9c6b14c86e88e7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d2ac04d4878ea7cb527516e80cd81b187e5c95267c59f5336cce35d9862417"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9fe0d97a0871757d30b5a77823b772310afa6100a9f4a0a5d01089c4b33a572"
    sha256 cellar: :any_skip_relocation, ventura:        "d09e61eb1fbd660ff55222c7e998e71420cb6819452aa564fbaee26450db0275"
    sha256 cellar: :any_skip_relocation, monterey:       "2ddab9ba0897cc2eb172ba37de6cc365145b4be0c8cd2c8226b7f943a1f95a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cbd3ac33dcc588a1a47e8e641d60000ad77d5e2d3a3c89de7e7f97e9af33f6f"
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

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
