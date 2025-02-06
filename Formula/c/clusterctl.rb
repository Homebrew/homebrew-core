class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "d604c1c767e6520aa5b1ebd035f09a1abb7a130a163a04ba4025242e17e436f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9492a79a184bb2ebf6429f4df3570d93a0a6a9c56fc5c6af13cdb41938b0beb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9492a79a184bb2ebf6429f4df3570d93a0a6a9c56fc5c6af13cdb41938b0beb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9492a79a184bb2ebf6429f4df3570d93a0a6a9c56fc5c6af13cdb41938b0beb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b5e9c009e229087def2c1cf6a18023afe2a13932fd90faee0d71362c6ca1ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5e9c009e229087def2c1cf6a18023afe2a13932fd90faee0d71362c6ca1ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dc48ecf7f655352b651c44b0df6eb13a6216ca2a6918f9cbfcf65dd2faac86"
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
