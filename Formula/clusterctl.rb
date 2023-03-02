class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.5",
      revision: "58770484dee6c99c10e32c06652e9f9643f78e9e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url "https://github.com/kubernetes-sigs/cluster-api/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4edd6397b3042e0898755198fde0be514df61573f165498cbf9f22dd4598721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4edd6397b3042e0898755198fde0be514df61573f165498cbf9f22dd4598721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4edd6397b3042e0898755198fde0be514df61573f165498cbf9f22dd4598721"
    sha256 cellar: :any_skip_relocation, ventura:        "df170d11db0052a66be362a73d0b2770bb2fa0bd5cd2c6f208930934330b12fd"
    sha256 cellar: :any_skip_relocation, monterey:       "df170d11db0052a66be362a73d0b2770bb2fa0bd5cd2c6f208930934330b12fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "df170d11db0052a66be362a73d0b2770bb2fa0bd5cd2c6f208930934330b12fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eac2ceb7c05d71ced4ab5d655ef545fff9d404538ca6b0100e18e2127274dbd"
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
