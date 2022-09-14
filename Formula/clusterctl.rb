class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.2",
      revision: "3c462340b2973b2e5aa15034725a5824f04de0ab"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015627feab7d1acbe8baff52b572ef3be06963efb4509a1fc5fb809a1f54004e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcaf595b1b771d87adf48c0e2ab9e4d3939ad30551790775dbf00f65e869884b"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc719a57c557097e64510fb19d294dc7f9511e8cfe21100e12511f6f4ee1df6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe734eb81c57839e02b067d3a1c8fad3ee63e62ca882b124ae7e286dc52de5ff"
    sha256 cellar: :any_skip_relocation, catalina:       "b096ba26191b6f719a340b66a44e12f8ea49d0d2e7cf450a9ecff10938908e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221329a5494e979f0fd6ac65e93651f25fddf62a4f47a5673347ace95ae599be"
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
