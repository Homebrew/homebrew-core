class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "a60168b02ab3976ed1216d39f3e1b1f31db84d3a0c48856366a1b3160c11e65d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75428c62d09f0e46e2f2d8294e8abff29e57f38480de2d8e61735dc7e3d0dc15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b28de2feada07ef609d5ad5012e53b2816b9fec927f1fc36f1ea9449c6871e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5938d22a7e3b9cda3e408579a574a74e7a157021ff7a3287c5f6ce41fe26ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "926be280edf9e5cdc8f7a305cb1e2613f18eb1ea57f932c3fe938bc5e48cefac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f01f37eddfa07cb6c75285a4edadee5e6a0398db12fd68a5e0725619708d4335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcde97c15b6d437622bdebbb9b41ed45c7aa8a28a7377ce2d1b98ca9486f971"
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
