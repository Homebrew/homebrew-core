class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.2",
      revision: "94017f2c8d97588d4aa2213713a71d51005ed62d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e634028a60640744048e1dddb3f21da7a24f04c998eb717904ae7422628f11a" => :big_sur
    sha256 "b8016cd8fefcb8b07ed76efa317dfb640aadc25cfd7b9cb069b5eb3a37bb8913" => :arm64_big_sur
    sha256 "ecd1a9d9cf3451a94f33b6564ef4cdf0b99caf8a18de84e1c8fd91dc2c22e79d" => :catalina
    sha256 "6d2ea94a1146bfa831717080676da93afa175a75d3d9f52f8cdbfa66fa70b001" => :mojave
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
