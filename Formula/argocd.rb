class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.1",
      revision: "504da424c2c9bb91d7fb2ebf3ae72162e7a5a5be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ec9ac7b50dcdda7d15c5083f08bbb9190a3e3d25c3df77674220bda51fd501"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "959ef0e3283d2a8ade3130e1c929c23d587b2b15cce2e500ffad69a36c1f644f"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d8cc9271cb27b9bd3ecf1353f1cbbec858de8fef19b16012a6dbbefa14c322"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c0558484023180fc9b904ca7083d3a08a49d66fc7564f5d070ac289a2da69c"
    sha256 cellar: :any_skip_relocation, catalina:       "a0ae1bf9c5a905516ac100cc7089c7251603bd610d405fda0715f3e96ee8b2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d8855af0f4f862215a4d94ba311f3d024370f78eff881398e64e3c0ea26d95"
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
