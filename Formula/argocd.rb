class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.7",
      revision: "a408e299ffa743213df3aa9135bf7945644ec936"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71752cdc3c26eed6f5093b08c16c115c145183efccaa9ddb75db37c779a8a85f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9aa54e0d625d05edfba6f9fa95c809ebd52d48068f159e6738b72ce795fcb2c"
    sha256 cellar: :any_skip_relocation, monterey:       "1df1d994617b7ffe160446cdb3ef9873c08eb1b86e2d28ca05bb8c73d86afc29"
    sha256 cellar: :any_skip_relocation, big_sur:        "efc93980f638aead3523c9b102e48a35d11bca39ecad904ec0039e855c3f2fd2"
    sha256 cellar: :any_skip_relocation, catalina:       "06f25c37b42c45f52b27c3568924d6bd44c9c6862550a6c780da522b34ce2126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad4af33e1a701c9ab392bd9c23f2aa3984d3eaabf4f447acd90d3811ac30e4d"
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
