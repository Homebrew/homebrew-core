class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.7",
      revision: "eb3d1fb84b9b77cdffd70b14c4f949f1c64a9416"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca05ba87d8052af20f79a28fcc5822f0ac10b3d072ea88a2ea06118503e2aa11"
    sha256 cellar: :any_skip_relocation, big_sur:       "32ba976ad68b3fdb6fb0ebe8364885c72e40dae653caf846f70806d2b5a4287c"
    sha256 cellar: :any_skip_relocation, catalina:      "dc3a6ea221d0b2aa2455f6c7fe1ded2784d5ada329a39c9a24d413b6f4d96b18"
    sha256 cellar: :any_skip_relocation, mojave:        "e8baffe94bf2cacbbcedb31248a6a8609556a45f6b49e953fe6b7f944bc77e76"
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
