class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.2",
      revision: "7af9dfb3524c13e941ab604e36e49a617fe47d2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4f483beb6a7c70df81e188b6ad7b928c5c7fc912852e18e40066914cd7bb054"
    sha256 cellar: :any_skip_relocation, big_sur:       "63f630ee37dd90cde8d46db59ebd2d124d1786e2b45939472c7ed054f586bc01"
    sha256 cellar: :any_skip_relocation, catalina:      "9b013c346eda8d9d3660217e44c3060e5c189a173d4a43c43cd917ed138bbc96"
    sha256 cellar: :any_skip_relocation, mojave:        "26199f8b6cd7719cc1fe9b61a37e5262c2f2b9a404dce288cc38eccbc265a700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670e76d95c136606bfbe23aeea210446249b009f2231f5bb86cf86d51b63cfb7"
  end

  depends_on "go" => :build

  def install
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
