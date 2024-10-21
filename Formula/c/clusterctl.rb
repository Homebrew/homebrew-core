class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "ae3e103dc2f42d0dbc0ea88448cc3fd0642fe8c2bd9e051241c1a4ec48fed1ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5848283087bba7bbb2c97febdb23730dbfaa0ad505e60f86a900d61c3f9d78f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e613b6b2510ce25213350b9abc1f8554f79851a22d6ebbcba73bc3222974f55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19557563e1846c90bf2cf723201d9a67f59a5115a815815199458c8c235b4b69"
    sha256 cellar: :any_skip_relocation, sonoma:        "2185c494c00f88068d89c7ba58005bee9e77965bbe809dba6a89a8db6f4538e6"
    sha256 cellar: :any_skip_relocation, ventura:       "453ea6630c0a8fd1339422867f8bf4de3c937fbe536330957e80f18b6fbe6720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45ee044824aa5d7fc7d72372d2bcd7ea5c5a9fa94208bddd5c22506b27e610a"
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
