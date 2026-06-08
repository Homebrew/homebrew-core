class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "30d77bda139bdf8f98191b93abc007a8df9c955b37a1a24ecc8b4cd57fa249a0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149a07dea354793ff15338916544bcd18c977ca453ffc1c24e9749a88f9e1d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df22f03beaac197f70e7a34c5239c8777aea8a139a808021831e158caedb9c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29fcfbce13f71bfe49fd5dcfc5b951e88536312f9aef0362a16c639f4c4b5e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee531f6d43ce3187e2904358d3df6cce6686858581caa0395070c11ad7ac6114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335a71a765e12f5bdde54c8d8cb28affd84e329c3e17c69e6655948ef3efd0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd07a7f256baf6771e7d9bcd5a76cd6088ef9e96df0b2db7c1881aa1e066bca"
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
