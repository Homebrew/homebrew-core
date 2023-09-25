class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.4",
      revision: "c27929928104dc37b937764baf65f38b78930e59"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7f82f15238414755d543db1af19fd61ae870066a0846edb42c72acb35aa8232"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78cb9f29ac950e994c30d00f0f1e192031dce2eb8cf5b3130079b7fbe583ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc55375bd3c024809e3f86ec5ae4a7de1c452a2167f607190ae4d9935fe76c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aeda2c6a439c8e5b90acc38f6db3df10c68b3622167c289395f3398a3035ff6"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd5085e456c52b5f180706526c61b8225f2b26ab41b9f73d760e71c01ee1988f"
    sha256 cellar: :any_skip_relocation, ventura:        "d21428324e790cbde713aa81a6cae6ccacd779f734d58a2903ef43950cb0501b"
    sha256 cellar: :any_skip_relocation, monterey:       "1e91bd9f2e7e96d7a2d1587abc3016e9c6650da2edd28e08d965a118fc1b45ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6cda925c73744b023cf66db2695a1fc824dee236c9739a3af70e1e89ab881fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6a58897848f1b2b9ffc0c96ecb950447dfa7a59d193930478a006583009a8cd"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
