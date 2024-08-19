class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "c2fe9d352b8076b752c09d6433743fe18b7f3e2e05ca7741d793c955d6e6d55b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd9019a19ee20346546455d05b841df116608a25b5c65f9503cc618136364c3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7391c91853ea01fabb448896723a086217d8a341e7f815833fb2c5f2ce9cdeb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067226482aa12dbec5b70d2120a0620d3a2d900875730fc54ea677643040f606"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c36f59f454ba60423a401c75ce9965a2117a9895c99c6d69635194a594c0593"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba6c7344f23541f1488faf74ba636224a46b668a6bcc797a165cd00b955984c"
    sha256 cellar: :any_skip_relocation, monterey:       "98f1e42344f06d30ee9a29d9ba5ed4771f412025a1c8cfef8ce570d0228c7dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15be6983e7468d91e06654225238b0c06d4d1818a14da15dd16459c979d8d06"
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

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "clusterctl requires either a valid kubeconfig or in cluster config to connect to " \
                 "the management cluster", output
  end
end
