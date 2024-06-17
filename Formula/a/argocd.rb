class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.11.3",
      revision: "3f344d54a4e0bbbb4313e1c19cfe1e544b162598"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "753ba8edbbfe04a9fb5b518ca8c8084375d8c5e7dc95214d6866920b392f2e61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13f357e3aed8710d11d642c90f976fc5b7c8f0f3fb32692d1b9c86f4ecb0d28a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "831188fe58ac5dc6f7c047bbbba7cc1dc43bc7cea915f196ff2abd7855824d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a5964142211b703d074dfa50368d8870cfb5ff94179bb17bc0877cee0f93890"
    sha256 cellar: :any_skip_relocation, ventura:        "d5a761c1e202f6f3ad00459b7e333bf62c2fbb82498d36a12055dfacd3b1e875"
    sha256 cellar: :any_skip_relocation, monterey:       "a5782934a1cfa0a409e35b739c3552d57969c462a361e7f1d904ad00c074bd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6580f3b3b45f367e078a473f432a91312470cba7bf10f6202a5fe0fdcbc5060"
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
