class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.0",
      revision: "91aefabc5b213a258ddcfe04b8e69bb4a2dd2566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0dba05f11ad72af04c09c5d9a7829fc5e6bb18a0ad7e54f9c35ee45f221ca04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "810406be572fcca0134df22dbf3bb15076984e03926318338542b3877c964939"
    sha256 cellar: :any_skip_relocation, monterey:       "d72412a06ea27cef68feb02d11e39ef7282af2ae2c0d6b088bfcbcb273f56e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "821dc05549c031e713ef0e23a71584ad811e12a16d2405188fa8198bb7301216"
    sha256 cellar: :any_skip_relocation, catalina:       "489a4ed331ad3c7bac94fd2a41cd3965614d3bf1cb3c76eca31cc9607c9610a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9176b4cc07699fd746aa807c127ad4ac13e6758b674df2b44f064be84493000f"
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
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
