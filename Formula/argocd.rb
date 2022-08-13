class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.9",
      revision: "1ba9008536b7e61414784811c431cd8da356065e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be322ff5f42ba6bde276c7d0be2be69b51185a9a73fcbb24d4ef18ae2e608f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f07ba950503018fd95496fd5cc7176b9879c605cb6749c521564bdfc60dea96e"
    sha256 cellar: :any_skip_relocation, monterey:       "08dad0a5a66405b002f48011616e59bd3425eef30d9a91da65daebd9d5da815c"
    sha256 cellar: :any_skip_relocation, big_sur:        "55a52ea8fead44fb188078c9e853357805ac6fe8b27444382e480c532c6e8ed6"
    sha256 cellar: :any_skip_relocation, catalina:       "c60437e0e13a5e037345b0a394b0e97707215a97be277482517757749ab96bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3351bfec19a190f6e30adf345c0207edd5f898b3ec8a5ced03d76f800bbdac40"
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
