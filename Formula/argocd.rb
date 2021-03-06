class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.7",
      revision: "eb3d1fb84b9b77cdffd70b14c4f949f1c64a9416"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b3f291d83c24a290aac7ae024f1c7f99d4a9ceaa7bd91979ebc31aaf8763b18"
    sha256 cellar: :any_skip_relocation, big_sur:       "435994ced70abb30a1761b05ca6736a985cea8688875033cac7ddaae11ac013b"
    sha256 cellar: :any_skip_relocation, catalina:      "7ae878a7faf11ce7325433af6db311edcd1cfe158e4739cc0a9d1ccb9ce1847a"
    sha256 cellar: :any_skip_relocation, mojave:        "43b06fadea9c394b2f9d686e3a694badaf8f3d61041e267ae6d0542aba63c863"
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
