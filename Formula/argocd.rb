class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.6",
      revision: "b04c25eca8f1660359e325acd4be5338719e59a0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "288984b46aa39c16319f0d661aec6277509a2be9dfee24cc7eda29d7957b17ad" => :catalina
    sha256 "ec3b5ed4671c35ce0f90cae153035add88a138c3f29722a5e3d1a42b967d9644" => :mojave
    sha256 "53dcc6e92d9465d98f83ccc65fa1d6d428027a76e8f2ddc5263d8fa37d94a413" => :high_sierra
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
