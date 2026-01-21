class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "2d2e5383ae2089b9fcbb6345edd3b300ee2ef658a80e0c00d649b9ffd498f8fa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5382323aa3c95480f49f89e25f243956759febcca25112174579a806bda05bb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a14580d381879c382ac2988252e20965040429cc3c2c06a39ff68257a5d587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a04e9f92f58a714643ad2c45063e81e9a634dafc4a65325e77db55cfaeeda28d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6d22f60a16757eeb22cd2afba623acbb7b87d3f4278a7566143ab530f73366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38831b446c1438b07d87f2cade3bc49ea8d3eafc8461b908931064294cd115a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8716f56831326b17f2dc45c9a18ffc40712b44b3f730d615edea4a6452149d5b"
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
