class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.4",
      revision: "8b5cd363e11b023c2b67a1937a2af680ead9e35c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags because, for this project, a version may not be
  # considered released until the GitHub release is created. The first-party
  # website doesn't clearly list the latest version and we have to isolate it
  # from a GitHub URL used in a curl command in the installation instructions.
  livecheck do
    url "https://cluster-api.sigs.k8s.io/user/quick-start.html"
    regex(%r{/cluster-api/releases/download/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a254503404bb785c6a3994ae180e48ba5038936ec1fdd5bacee37f600f89acd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae6bb0bd11d3527eb6d256f6411e6ba5445ec43b3f0753672bc2c138c5ebebfb"
    sha256 cellar: :any_skip_relocation, monterey:       "dd0bf7833a442aaa575d61090fdf777dff1ca80bfaf03dac8f3682d8b8795cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "23cdf32174127003deaab7a6c25c0654422f26fc54c11b8ce6556ba6ae4401a6"
    sha256 cellar: :any_skip_relocation, catalina:       "bf3a3604ac90492eebda6ec602c22296974c3ac77311c7f5e0938074e3e68476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c68a3cc91fc08855e157f5b3f8e5f993f584497eb3247294876862b75bcc80"
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
