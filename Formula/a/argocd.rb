class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.8",
      revision: "7ae7d2cc723f5408b080a31263e705198af08613"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ea937de301363b739c7e9f907dad28a3a0652b089679369f2419cfc8e62d537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d00791204337d32e9b82f6a33da7438602716222fb98006fbda87c78e8fdc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f50c525972d435b7f5b904d186f458258e289eda329eeb87581c4108687e1db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbeecaf17df48719a4f7dce4c197f56314a54efd194085f0d33100e1ce1449c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "044fa247e26656d6ea0029b5c529ad9f92ea1b75291f07b6829ad6b6616767dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc6251d121c1777c86fe5aa40f1d1724bc7d3c4b54878ab7fbca1da3db35fb7"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
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
