class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.2",
      revision: "9a7b0bc35048835516fc5f5f31a93d4c1bd61242"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f1ad0a64f3378085d6bfd76bcbbc2bbe3fb0c8e940e569195c36911e52218be"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e3517f71dc8e08744628d5b2631497731a699fd781b917eef5b047936f60bb7"
    sha256 cellar: :any_skip_relocation, catalina:      "dadc4a6d1a0c36df7a2c348afef2bad7ddab6da2efbfd6433ddf572350ccc80a"
    sha256 cellar: :any_skip_relocation, mojave:        "b6e4db0d0f40f9f9740b76a9e0402cd77c25d22c6c1623d260c7743777112423"
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
