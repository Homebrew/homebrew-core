class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.6",
      revision: "9db2c9471f6ff599c3f630b446e940d3a065620b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80abf38d0e0e51efc30737fe124b0df9bda6a0f5a639a66e6fb3c0be6c473a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e91173647431bd1e4aa322b9acec9d65df621994b8489ad5c2af277af88d45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc2e64f0f7b7e5d65987588f3dfa17e4cc50ab559c62095c752c3ee93e5086d"
    sha256 cellar: :any_skip_relocation, ventura:        "247d4053d7b9f78f0342380f6a64d886c4cb6f93024f5bc7ca132c2d31134648"
    sha256 cellar: :any_skip_relocation, monterey:       "db703d466396285da5df8b3cc74b1315d00efafffc0c0f724cb77ffa14d572f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f9841c5193ad8103652333c5600dc572d76429200c6733a972fafe7a09003a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe2241c50a73c086267e8bf6717897755f2f0c742308cbb3d40abdb4c402fa2"
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
