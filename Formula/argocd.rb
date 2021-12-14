class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.8",
      revision: "2fdaf7a9add4ba6d6657d28dc32228419cb8b8f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5ccb37e71ade8c364d47acfcc746a86c07c0fc31808dc9888ab67e4be436ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91a0f87666cbd890cad991ded3d2c6f933e493db47dc11c36bfffd36e81b2c9b"
    sha256 cellar: :any_skip_relocation, monterey:       "a4289a5c3a45c2f140b3812c5e1327d0ad5da07a894e47f1f3e125812fb09dab"
    sha256 cellar: :any_skip_relocation, big_sur:        "b19a1eda014dcbc2cf7b53118519ab8cb9cff3eb60b5cb3bc2d34ab22e3d9de7"
    sha256 cellar: :any_skip_relocation, catalina:       "1c19f428a405a95a24e5b8a87029d0d809fa29cb963fa11a58cc54dbfefb4ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5ca6b3c698c8abfd8bac02cf0b71f12372870e40345edbfcfb9063bb473e02"
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
