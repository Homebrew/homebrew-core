class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.1",
      revision: "33eaf11e3abd8c761c726e815cbb4b6af7dcb030"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48b41d946e0bb22eb3ed83c4816bc3e49253fcbcd8407c6b85934d06db1d354b"
    sha256 cellar: :any_skip_relocation, big_sur:       "356705da806bbdce7015e7856efaffc8ca9d19d31a36132c1e6db482c17155d5"
    sha256 cellar: :any_skip_relocation, catalina:      "9608827a7c63444e0c6655ee4c8ea637fe517813ad95607190e9f4555933c009"
    sha256 cellar: :any_skip_relocation, mojave:        "6e52b8ae56de046154e444e56e090129e13a35efd1bc052d45325ffe64bf8034"
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
