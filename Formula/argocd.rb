class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.4",
      revision: "0842d448107eb1397b251e63ec4d4bc1b4efdd6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e988ce4a1b81857526976d30a82399c719aa9940b40c46125d603c285684abc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d12f922914989ead308ca0c907eeabb72172b307dba04ea711a3533eb6093420"
    sha256 cellar: :any_skip_relocation, catalina:      "c511e49aabea88fd9c0717ef789b6389146b6fa9a1b7ac4b8ce459f821f342c5"
    sha256 cellar: :any_skip_relocation, mojave:        "741813e6e8f620812a349483530d4d375460f8d4ca2cdc047691c199ff9b7e81"
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
    bin.install "dist/argocd"
    bin.install_symlink "argocd" => "argocd-util"

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    assert_match "argocd-util has internal utility tools used by Argo CD",
      shell_output("#{bin}/argocd-util --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
