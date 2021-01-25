class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.3",
      revision: "0f9c68427882bf4633d395cbfcd7c9271795fd9b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "27cae6214abcddea8cc1027ba39c9f9de5cf08ea18d7a89c5865ecf28feb1952" => :big_sur
    sha256 "6618015df8533bc38ef1c1116163ded2ef8b745fc758b7d347ed694630c2e525" => :arm64_big_sur
    sha256 "418d71b27e565b48480615dcf9a28593e3458b2a4ee5d54fd46dc3088aebc14c" => :catalina
    sha256 "1ca10671cfc116403a16ef24165ee8742ffb07687b377ef4ab7c63dd2304e0f2" => :mojave
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
