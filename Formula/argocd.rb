class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.3",
      revision: "0f9c68427882bf4633d395cbfcd7c9271795fd9b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "419d55cb6010481e9f284c770f4afc648e2d33065f31a7e6e048f5ac56e935b2" => :big_sur
    sha256 "e99c7c14da2eb1223680585fb9abb775c9da5cfea72ec442bfa1694565a357fe" => :arm64_big_sur
    sha256 "a7739e27a93a39d223055454978babe2c7495f21eeb7fbd26285d368152a5dee" => :catalina
    sha256 "1821eb3a4c49b6bf8b85b27753c13f6875a5eed323467f623793a70cf88d0a78" => :mojave
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
