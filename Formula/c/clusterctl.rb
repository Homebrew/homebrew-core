class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "2dd129c839871dfc74142781ffcf8eeb465c56845e41e39105491c9a94770b6c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fed8498eda5ce9c5972e944467a192c466bd97b91a114bf8126536429194581"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27f6ba0b6037612221d9e578d360b3a7f34af83338129d61a09571650f244661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "999ecc0f49380498699a0d2916ee43a9eab060d3edb284f619d6d0f05339faec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b64cefdcc41658bbeca7366d0be4051a1b3ab80a7102724d66baf45e7685eab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ce259d8bf31178a02626913aeb66497e951ef6b5a29095c66bf6404658338d2"
    sha256 cellar: :any,                 x86_64_linux:      "3bd5048a5cee0534c8f46471c327f77916cf3f5cfc43c3d8c33fddc46a2e460b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
