class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.8",
      revision: "ef5010c3a0b5e027fd642732d03c5b0391b1e574"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "37b46e1233585c99b1793f81b15485ac95afd63ff9d568b21c22216f17cfa09f" => :catalina
    sha256 "8c864e0235ed23e19aea679602756f5f4d42934b27ba055228678e5d540f711b" => :mojave
    sha256 "5cd1087ba3d2978c7dcfd9f79f19c171e43795e647170f51012a85892914df78" => :high_sierra
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
