class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.8",
      revision: "ef5010c3a0b5e027fd642732d03c5b0391b1e574"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "39cba424c74280c70bfbfdaa017d18af5264a1e2eed7cb52f4cb48fdfe856df9" => :catalina
    sha256 "56e68cf7ed9d08d47327d60fe34befb386f29a8bdd67421ad14dfe87389aaa4f" => :mojave
    sha256 "171f3c42e5f2225b709b46d9b2f5055c28562b04d77c8d69ab5398b62e1f7458" => :high_sierra
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
