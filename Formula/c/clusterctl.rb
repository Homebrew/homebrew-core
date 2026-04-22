class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "cba045eb44ec912af352c1039eac3400fc9d3babd47d4eb8bfcb204530e9cc30"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac76442f04fe177133e542e7f636dae98058bce16b8921445f2cbb7e6fd0e5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e654c19791d00c90c2683ba11395c501550f25c606ef3f490121f798fa2836b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d6e33fe84f5659a584cd2198121928ebd3654c5e4420896ee8ac777eaf3536"
    sha256 cellar: :any_skip_relocation, sonoma:        "dab5e23f3f96987c2e76ac36676067e3bcd2422ce9c4e11a26281fc0e0ec74f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f21e303a690afaf0373429fc534f5004238bf07ae0ca2e04a75dbdd30daa901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54db13d11aed088ab1ad3143b18868834b2bf6ac17856679c233e945b6c5623"
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
