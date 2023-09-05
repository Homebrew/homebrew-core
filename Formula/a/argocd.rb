class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.2",
      revision: "dbdfc712702ce2f781910a795d2e5385a4f5a0f9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "548ab997f3827a322e3916eda7724630361bf0a09aa4326cae0f6b5f563c2f2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3a838d35de600e623d5b7f44ac4f6bb3be932db6d70edda498a70212a26464"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4686794d51efcd1f1cedaabc4a9b0bbd298158fded8dcdd62da72c4fb05d4cf"
    sha256 cellar: :any_skip_relocation, ventura:        "c600c70911f394107aba1a60f9c1181a9b72f805cb8808ea3d8cbfcb6650905f"
    sha256 cellar: :any_skip_relocation, monterey:       "185415a3888b429c8a066a65fbd9b2c9a1cc55d472f88ecd6c18c79897f23053"
    sha256 cellar: :any_skip_relocation, big_sur:        "a935af2a15bd881d7fe75396581dfbbac231648d3fa715367521b8724d50cb82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a642f87eee1baa7e219db9043e6334c316a31f7ee9d57ffc144cd16ed1811fc1"
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
