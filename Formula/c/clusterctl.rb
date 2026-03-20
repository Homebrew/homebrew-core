class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "1860e13d6def424076d2be928f8a770a037dbb6f02ab589565b11b71224f943b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38463122f3aff80444de75c667472862295ea21a4c2a3bab0fc3a2419efb1283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497b87805313ab632291ae1ee90fde5b167a9ffc8e0b0107536d5414a5a94ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54133b93e75909415ad2cd4905d36169fddfaef8fc2a61ab641eebcf259e4263"
    sha256 cellar: :any_skip_relocation, sonoma:        "43def13bbeb9c4626b86cced4f49dd1e27b2eb5f282b5c2dd27e375e75ff0d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bca2c319ca4c570d1ca5a8c3b6af53730157f44b44bfc833a5308d0817e425a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b779b019a0372d4ab9c6e0925aff405c76c2d8c5066a08b21fd04623a4772290"
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
