class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "ea7c481afe86381981aaa7f4d7ac6c8ec7dc66fda10a1029c62deadf624216e0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eb2c76cba05c7a088ed2fa595dfc8a0f43a0e923861d8403d33373e8f2bd166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1db74c82859242a2f30d4d2aacb5c60d138110c9eee39b187c2ee3610602293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72e5860972a5713e70a8dcf79103a80105578aade35c5d9fe904d139478e485"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b53529e4d3136b83a2c4b209d7720d2a2ce2fee7fc9086b1dd83cc4f1cb8100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afaf790e8620131a831b1266560ea7334d976ce99a7893a66ae62270df25febc"
    sha256 cellar: :any,                 x86_64_linux:  "a14533bbd8a3f97068fe339acd8fd9140a85482bbbd463d5757707a3b830e002"
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
