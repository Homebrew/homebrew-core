class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "89ff7d89e1080a96bb3db41cca79b1613b8e572f302a04b0cb969be0f2864c21"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbbfa6d1966bb81b929560d9f08d0b8f6971e21cdda1deac8f94636494d86214"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47de42ea909a0745da853d454d6102d7450088a5c5ca1fd34edb7aa5cbe6471e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f51fc3ff84ace8b4f2c8f67623b379b3fe90832144ca86e8403a01611513de96"
    sha256 cellar: :any_skip_relocation, sonoma:         "e00a4192fc131e8f149296cd26485fcfbb4ee06c2ddc0cd372f3139df93ce6e4"
    sha256 cellar: :any_skip_relocation, ventura:        "706309e973bceccd5e5ea64eb832222dc1e574f14aa037bac27b42b2f8bcdabf"
    sha256 cellar: :any_skip_relocation, monterey:       "d26ff6c17d0fd5ef8931a0045142c65a30de6903c87d4ecafd52fdb22832caa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695d98e29ed754c2f16283df35b189ab1dc6900a081c91fc09b0c3467b29f8ca"
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
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
