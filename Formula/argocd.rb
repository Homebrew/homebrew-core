class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.0",
      revision: "6da92a8e8103ce4145bb0fe2b7e952be79c9ff0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2a4de5e977cde3f36259882d35b22ba8ebedb84ca51b32818b6d7de507c6d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1ddbff4c938522c9fa78517761c243b970ef54d592e54579bea1192df694a43"
    sha256 cellar: :any_skip_relocation, monterey:       "19a65a2929d70525266e98695eedf65eea8ef5b738860284149011ddb538679c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e51e6073bdebab0d18db8f4a39aa91a255be754537a36d56d75556065d1e4a53"
    sha256 cellar: :any_skip_relocation, catalina:       "982a85eb4779f89a102c0fba4f48d23942a9eef437cd0b35fb939c83d2e6a05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022d69177f1bf4d1bca3d14dd43bd96146e64ac96fe7d61d8f6174163d646c43"
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
