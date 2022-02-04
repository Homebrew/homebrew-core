class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.4",
      revision: "78d749ec88bea5a5e851fc48b9404fdf067192b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "249b7f95e634a4e1f0eef667b7b0b736fc6421b8d7c3473c1ac2ca8dabcb0625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d96eb8675e9694b002ec4f93e32d245540914c194018f6a5b75c68f2df9f786"
    sha256 cellar: :any_skip_relocation, monterey:       "cb4a6aea2812ac287befa40eb8c9873199a4c9208069c19822b2a64390c220be"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efd0601fc5f8e3e5da6295b2c7c725ba13d83ac5e3f53b95a4274bae9cc2795"
    sha256 cellar: :any_skip_relocation, catalina:       "89a7bdb0d80709ecc27c1bf281a44f7a3d3c115031f561d0e02a2214e5f855f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1cb6ff1a40994944fe19c54f44d2b2cdfb3ad35cc5b26b867fc27ff01454b1"
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
