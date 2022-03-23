class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.2",
      revision: "ecc2af9dcaa12975e654cde8cbbeaffbb315f75c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca8585cfd73ac2b7a5652dba2b921eb453fe6d6d8cd8bdb4d4bfea8198288c86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c60120f78bb7c56dea34d3661103baae8ddd93beea7867dc1916a0cf1c10aab6"
    sha256 cellar: :any_skip_relocation, monterey:       "a55ff2d24a7597f67b3740ec237d8b1473d5a4a5d562bab4b2674fc063378e3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e595c18b0f93e7688b8c88a50af60e5fd8133e59d8ad67ed08d0a2f9b5f62be"
    sha256 cellar: :any_skip_relocation, catalina:       "400ea54e916ffd2e3822fbdf11ab048ead419a596337b6ede9731f667d286f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e4b563b65c5f4ac2a408ede89a6e6b256bc70d3a3e91a53941062040a1aaf66"
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
