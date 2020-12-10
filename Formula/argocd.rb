class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.1",
      revision: "c2547dca95437fdbb4d1e984b0592e6b9110d37f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "27b433ddd56ac0143ede08eaeb6aa40940f8b9ce814daca8775d98638f53992a" => :big_sur
    sha256 "ba36694fdb10124568cb46e70cb54bf2af39f3301e907cec905ea7d8cd284512" => :catalina
    sha256 "5c4d8e6d3c1c6187e516ec83c35c5d645024e1136b33de7500b3af6ca495f4a3" => :mojave
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
