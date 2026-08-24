class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f7f14651f28c08678c4e66402b86ae455e8569e0faa0f6800794bee400a21d48"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "698768dcf93818eb14896aabec2a717567ca23ad22f438ccb266190845daf25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a730c843e621c065f5e8c945f304f35fd5d6a5037e1936cd4b8852c3c441f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf8a6d5915c518bdefe8e853c65dd6856928d3dc5db92b7795759430fc2b44a"
    sha256 cellar: :any_skip_relocation, sonoma:        "443dfd178cbf57ac21ef2f418be2a5e8d5877e9fb8e7a573dbd1da65ee074791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf452e8582cf1d3ac88b0bf6317f185696e17fcca4f067e67790762bb10a26cc"
    sha256 cellar: :any,                 x86_64_linux:  "55e9925c956d9c2413c6cc824a7c498b59f357cdf307eac0d2565fb44e0da539"
  end

  depends_on "go" => :build

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
