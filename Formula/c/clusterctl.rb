class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "2d4049d72657d9f3fcf9a938389356888dd193994b63f3bb26c4543620bdc18e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d725b2fd5a3156a1901f7ff972bc1af38a37db7ac0166e6ae93e527f7edf759a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d725b2fd5a3156a1901f7ff972bc1af38a37db7ac0166e6ae93e527f7edf759a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d725b2fd5a3156a1901f7ff972bc1af38a37db7ac0166e6ae93e527f7edf759a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8748795326aedba70f298c68be2dddea7d57420837693db0d35c13f716cbe3c"
    sha256 cellar: :any_skip_relocation, ventura:       "d8748795326aedba70f298c68be2dddea7d57420837693db0d35c13f716cbe3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3907ff21bb74397156f0b0ac2737ff492579ba535d90ab6171baae5247a1b0a"
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
