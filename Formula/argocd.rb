class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.4",
      revision: "f8cbd6bf432327cc3b0f70d23b66511bb906a178"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae3a48ab6ca9106dc1d734faa8227ff33996815ff04d1b98e1fa38f1fdba38fb" => :catalina
    sha256 "e65c0481754c1de1b2104f02bbc50b81d21c292c6d7e8970b58c24777deae59b" => :mojave
    sha256 "26a3af94bc321c1d0898077b5bcff3c45423aebd000c3a069a5484a6c253af9f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
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
