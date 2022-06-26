class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.2",
      revision: "c6d0c8baaa291cd68465acd7ad6bef58b2b6f942"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551b58b4eba445dbda93ffa313f9163554d3c365ce92a1fee428952e96348e9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3496e412cd58a13addc830a76f88a26a5eeae7078a25268ba2d5520ea02a0b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "f7485a160d0fb0df79a0e11f974555ef5602848ca29351bf1f7dceafe42e2acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3e4dbee5fe7e8fd03f25dfbd2e2533e09cbc68b7069ebf18c7e1ececc8a17ec"
    sha256 cellar: :any_skip_relocation, catalina:       "327c4441f31af09b058928be8f36b5ee689d9c238c6867089e3d39fb7953b618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5910779a0cfc92a7373dd4cf45c267dbb7eb9ca4a517a26721399c91d917b1"
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
