class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.1",
      revision: "aab9542f8b3354f0940945c4295b67622f0af296"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0745c99d82b1b040663cf620fcab3f4d1a236e938ced81371683c62d28c0f309"
    sha256 cellar: :any_skip_relocation, big_sur:       "57befda523e53d7fc95958b4f3838d659f58376c6e24b6dba16c0a1fc339c772"
    sha256 cellar: :any_skip_relocation, catalina:      "faff4aeda6104aaf51f076351eed0f2f7c183daaa233efec10cca1f9ac1def69"
    sha256 cellar: :any_skip_relocation, mojave:        "30b62ec6e5bb23470bc7648793cc0e28ca5af2194937b20c0726c9e89c5cfb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4261b573789019b3e8c232152facb13a23ecb292d23ae82868ad80a5b8bca1a2"
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
