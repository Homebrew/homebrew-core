class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.5",
      revision: "d0f8edfec804c013d4fc535e8b9022eb47602617"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44341e62bccb23ab8a57d6400471b7197754681c7e1a8d1f93c6e37fa69c6a72"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f90e5e100cd1c4f3fb3f945950a73ab325a1f0275782313d2aec8fce8342895"
    sha256 cellar: :any_skip_relocation, catalina:      "c33d8c368a9a107660e126a0cad3c4cca44725156abbbda054acdc3c80dcfbc8"
    sha256 cellar: :any_skip_relocation, mojave:        "3c8b635b830fb1bf377ad8528dcc543b5c28e47f02aa9093046695e4a23b8b0d"
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
