class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "59bf1aa1460714dd4047184412eaeac0ac10617149cb1155e20dfb004b7dfce9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb87cdf8fba0c7e9db2a91b54fd561fb064dd56b8dca9f85cb88e92f57e8684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f26b03b01030c409478f7b3189554b706a034ef45282be5bd5440eab21efe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16799be2ea0c13a5a3b95bdfcbf7f22300cadbc520939428b15dbf7509d87dac"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1bb20b5e9cb643901b4fd3fc77811a5ac72f85965b5312558dc82c4963e4606"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28e02465293de43bcedd0833901382ff30cf989a1a6055c0090605362d9f2949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c2b8283423010983773d49865feede91e788e397f057899c58eab4fb1777a2"
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
