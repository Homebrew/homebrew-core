class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.0",
      revision: "fe427802293b090f43f91f5839393174df6c3b3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b407a1ddb392ea963d452d7a2bc32071854b6596e8f994eefc66cfc745d39e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1219bfdff16c4a605dfa97c7f27e82ce6643fcdaa132c790f553cbfc970caa49"
    sha256 cellar: :any_skip_relocation, monterey:       "815cb680388cfde3cc173b6b97eacf346905261d072dd5f4cff2b96bf0848787"
    sha256 cellar: :any_skip_relocation, big_sur:        "280669dffb582d28368f2bb19d1d34f8685f52310188c922ad725bbacc539172"
    sha256 cellar: :any_skip_relocation, catalina:       "c6e1861ba43f2157853e31056131823191e4c38f4bf2faac67df1fc857b4515a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5046187ec43e8bc20baef78141ec649771c89527f4d6780fbdee14f6dec4cc4d"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
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

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
