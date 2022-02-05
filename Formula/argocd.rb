class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.5",
      revision: "8f981ccfcf942a9eb00bc466649f8499ba0455f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8cf455e545a138bda0bdc53407343a418d6f6b8647b968134d77cea91867bdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c9a67fb7ef14f55acc1c9db6053fabc90a290508bf308bd7774c2eafac7c236"
    sha256 cellar: :any_skip_relocation, monterey:       "c123abfc63a6c51160d47de1df9fb0b5bc13efa1060474071d42b0aae23b1a11"
    sha256 cellar: :any_skip_relocation, big_sur:        "5719e351df2c3d3ac37f6638142d0ad41ae789d2bf643863ea1f63d1db8daa38"
    sha256 cellar: :any_skip_relocation, catalina:       "3b3f1ffd02086c51541e1018035e2fcbd792e0b6c5d1d4511f8b52535c958e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25fef46a97a051745c946a983f22ffd3fc28ce3843b74a719429af6059c85ded"
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
