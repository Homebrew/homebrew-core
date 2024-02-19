class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.6.1",
      revision: "a150f715f5a607ef172dbe96615ffdf1d51220b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5278b9e17150edcd7b8f8b8dc6e99948db854c6af59eb31d85149005b77b6ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66880740faad325f5d50fd9273de577a7b4924968a41ec616269ff62992b9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fde8f20e933433df636e5ad0b6a165df71ae54a8798fe70a648d0b2fb6b9047"
    sha256 cellar: :any_skip_relocation, sonoma:         "36b96b1af7c40fcefb3dc68ae2eb9fac4bc9d153fd52afbe8b1b2d7aad3056ff"
    sha256 cellar: :any_skip_relocation, ventura:        "d1d68ce9135c20a012fc911afabf32e6e0a585ed9852a7ba79a4818f457150a9"
    sha256 cellar: :any_skip_relocation, monterey:       "389b8deb170380363a1db578e4cd1fd286d8f0d3f8ac242a4a46482473c1fde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768af15b2ea77e8303463325cf53618725134a09f0346956f28a42ed6f15e68f"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
