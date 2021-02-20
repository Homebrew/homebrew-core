class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.4",
      revision: "28aea3dfdede00443b52cc584814d80e8f896200"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "439249642d57325b6fc94f1a17b5b18aded0f589a6547d537382920c179eb94b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6115b5c5bb75d070e960f5880e6c308f917aab2b4286705af951e337c98a1a9a"
    sha256 cellar: :any_skip_relocation, catalina:      "158999c9ebb8e01fd22fdc66de7fb021a51e6a4e416fa8d313ca1db7d5b0bb61"
    sha256 cellar: :any_skip_relocation, mojave:        "9b13902f473aa2ad2d5599782e5bc02445c5ecc9ba7fb3732e80e6cb91289ea2"
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
