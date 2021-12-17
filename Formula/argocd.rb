class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.1",
      revision: "122ecefc3abfe8b691a08d9f3cecf9a170cc8c37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392a7896fb7621c36eb8533093f07190216e11141701a87309c26f5f35ae1b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ac3f9ce599c6086eef55d85e4cd36ae4b8c27864cd747598b0819cc7e7fe75"
    sha256 cellar: :any_skip_relocation, monterey:       "08c6b077608334c124fd9107cb5b0e607129cca5f51647a3596cd693dda5f89b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f386b7c76ccfc2b7a9624f55ee841d1184a875800bb280144e881b6aa6531cb8"
    sha256 cellar: :any_skip_relocation, catalina:       "26eda9705b6034349903c241ec3ae0894268f22a43c0c8defef6c595d594823f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3516704a1ab5b9339c81eb84d6da56dc8121fac0dd9bb6fe860f375131fb38d5"
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
