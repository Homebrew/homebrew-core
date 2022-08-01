class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.8",
      revision: "844f79eb9d8f3ab96d4ce6f8df211c6093a660ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051411abfdad2e63c8203aad56eef54f16f6698b3d93f578ccc1a8a3b41fa4ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6baef3997322c350530328353c269471d8da8a267741996e6ac1bf14a0a6484"
    sha256 cellar: :any_skip_relocation, monterey:       "1b432739d20ce12d3fc72946f197b238b70445fb3c47e40c8f19af12bf9f398d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3f7d2fb2957f789bf5b5ab591eaad7336f96aead6d0fd8f77d9fd2f42b1ab73"
    sha256 cellar: :any_skip_relocation, catalina:       "22f2e75d3b06a2835d7102eeec8c2a514f0242722229aa0e79932df34a25ea25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1a14b554e39aff15a58dd6587fa9a386bb81a601357d5bcb3289b149d3e9fc"
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
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
