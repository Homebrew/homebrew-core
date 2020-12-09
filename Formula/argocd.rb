class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.8.0",
      revision: "30348417a9603ec1c0e40b335cdf0fd83192bad0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1242f304ab3f70e8c7301e1f0b319576799dbb0b8eb42bbe1ea716b1ccd4005b" => :big_sur
    sha256 "6099dfb387414cf1020b4842bae955523465e665c9018b9f87c63af9e2e13722" => :catalina
    sha256 "a6a29f0d77cde398d835dabf71ae5c4555a6bb419a0b4b96fec2006f0e668b54" => :mojave
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
