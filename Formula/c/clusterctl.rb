class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "8e180de174bb9f675635862d769a9b8466d27a7cfe3ce16847ea7e7e5a451e46"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1023af754bf173f4bd3b7421361d392b24e4de05b8a4afed30fdcad4ecd74e7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada5630752b60131ad8563d162838290594fef572268d4c0bfa58c636f63c6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a5dedea3ebce7ff8b37a82ae5d8005b42aa526b4cac2ebadb05389816596f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de45d33add9b6835b79e33f045ace310eb2942b0f897a5eda2924b54fab955c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "94746ff6aaa3d8ff80271c70feeade2862dc9560c050a0afd4ba214f523e3abe"
    sha256 cellar: :any_skip_relocation, ventura:       "d8525613a612bade74bfaf6482a1237d993a26c9f48ad7eb04ef785f36fdac31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54224ddcac9e3e12783624bb51c09bc31d2f2d339dd09948d1bd8d64235b33a0"
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
