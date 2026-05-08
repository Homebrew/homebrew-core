class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "19e5afc32031a72d86986c096f5504e49419ff55e518eb6518e6aeea45d4cf3d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04015871569cb0f89a4989f93645723ef802fc60f8addbb42b77e579c6b5b710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba2d4d9e713a6292d5f8f8019750364e2eacbdbc7adcb5f95c396148cb2698c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796ce3cee60eb2584cbbc97d78f9010aaef9f8566655527811d506effc089c16"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd92f69c03eff7e6422d20f9341f73b98a8cb13d86e922a1d5d295c1e52ad566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15cd476fc169b0e251947707d4b5d8e15fb8629865a06d4b93766e3f1fecd839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0444cdfd038220f3a97e04f369efc05301151e5f96c3d1e52d4fd507b1eb92"
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
