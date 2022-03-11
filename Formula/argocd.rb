class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.1",
      revision: "b65c1699fa2a2daa031483a3890e6911eac69068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adc3c5cf3aee31ba633eae6d1684172b27cf1b70d82873fd47f079f3736b5022"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e5f9eadc0930ed618a2911d704628de05721683ad5feca26eb5d6efcdc3b66e"
    sha256 cellar: :any_skip_relocation, monterey:       "25b58259e9db0d7bd6a5cca7241be184b3be637a6f7e2fedb777a638736d3370"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfb9ca9cd1028a61c57181beea4d039440a10ea36f29a35ba19974df7c398e3d"
    sha256 cellar: :any_skip_relocation, catalina:       "245b6de4a9381ccba7e890bc5193df66269a922fe22561844e28d8ce488b33a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9b48cfa9949468e2b587f73988c589f74be669d8761b1a4a5462444ae7d201"
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
