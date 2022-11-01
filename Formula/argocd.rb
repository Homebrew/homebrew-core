class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.1",
      revision: "504da424c2c9bb91d7fb2ebf3ae72162e7a5a5be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d3bd2a7bef356c1174d890673f0a559ff5db306c26acfa82eb9eff879fff18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c89759f9ffb6ef0a31c2728e98c7d955144812aa588e272966ff09a7ddc97ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "78e24b8dc99351b5783acb3e1df3066495c073ba67c43a415e199405134c29ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "6545ba138ec95ab0eb1f8e26ea20ea73a7ab7b9f26795141561900da2acfe4c1"
    sha256 cellar: :any_skip_relocation, catalina:       "b2d06121fdd40c7c622423b82f1ac3506fb55998ff18dd5fa5d3405cb94aa149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e68534502bfe0c4e10644fb549b941d93ed2f4d3447cdf7c93c927faaf8217"
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
