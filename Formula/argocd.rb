class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.7",
      revision: "a97230859344f8906502763743717d7ad7339c55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d7d9d0a69da65241d4991d755fda01f2e3967df8d6267422c329b257ae4a294"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa183e49d795f835f718fa3321281fc649de9370e832668d18b6b2521b7f8e5c"
    sha256 cellar: :any_skip_relocation, catalina:      "9db81b3114af30415bdc66ed5d7f1fb0283128f5cf54ddf0fce7992216144db6"
    sha256 cellar: :any_skip_relocation, mojave:        "487f4fb7aebc6a4e5168e84a49dded2012622eea0d926bfa20f6fca34c926658"
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
