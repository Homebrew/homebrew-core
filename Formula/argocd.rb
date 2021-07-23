class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.5",
      revision: "4c94d886f56bcb2f9d5b3251fdc049c2d1354b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b550f85106ca48abaa9f57f851da97911c2ca36957b86b64a0ebb15f57f20b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "22b393539caafd3aa9517684125412e657e279c0835754797bcca427212ebc26"
    sha256 cellar: :any_skip_relocation, catalina:      "1a03ca8526778811395dc73aebcc4caabddc6fdf8b08551000579f3a0e6144e4"
    sha256 cellar: :any_skip_relocation, mojave:        "26be6e642c38e0e2d90cf374aa6aee0b5a6c176ec6d631bde33f1cce137e155e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc77b5c6a5bba780d111a60f819d1be5febd0c64474953fa5ad5b5874ca5239"
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
    bin.install "dist/argocd"
    bin.install_symlink "argocd" => "argocd-util"

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    assert_match "argocd-util has internal utility tools used by Argo CD",
      shell_output("#{bin}/argocd-util --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
