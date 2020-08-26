class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.0",
      revision: "24b93197e05d02e31f6b788e53b529cadcf2ccd4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ff9ddcc4367721f53c625479e09c3531ffe8bfc77a144f1407889aa0c63bd37" => :catalina
    sha256 "da7b4efbf979da5832f27e24c38fedf192357e429bf0a5a48719b080bc35d59d" => :mojave
    sha256 "dc35bb46d71cbb4a735c79e838de6df370c14a647045fb024d0205397719ef9e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
    bin.install "dist/argocd"
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
