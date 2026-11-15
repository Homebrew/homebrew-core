class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "0d22b58ffeb5b6bddb9085a1b35c059e2109507e8cfddec7b54b1fad87f49849"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8cd0f584485a43479b374bdde20a0b9c6adade5b5f32c5b77e2bab18c58caa5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "623e4ed97822c0fa89a3122c19e7a995497eab53bc3598ce0484a61a2b74d6b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "382cad8939aa3acc8d93f21bb8163f53c15ef5a8f8a970d1b9228c8cfd7f6b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e6663e9dc64ac2cefa5a11fdf01608059ccc928290cafb1e9c4b567cdadda85"
    sha256 cellar: :any,                 x86_64_linux:      "ed54cda8dba24c61d72200e2d4306838ffbbf2f6251f2c7e267e43ab485ca564"
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
