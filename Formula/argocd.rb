class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.10",
      revision: "bcb05b0c2e0f8006aa2d2abaf780e73c9e73c945"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7d015406cebf27dfe2519a1c2dbdd33355d242613eb1dad3d9bf9aa6a6a75be" => :big_sur
    sha256 "40328099a12fb75032899af24496d69ec29dc9c6950aaef020c68c962d4d95d6" => :catalina
    sha256 "0d0a2f699e61233d8ca7516eae46eda58a79f28ee1316929ef7d7ea7d382ee1d" => :mojave
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
