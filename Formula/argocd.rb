class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.2",
      revision: "7af9dfb3524c13e941ab604e36e49a617fe47d2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52cdbda71f68a32ecc74c469eb3693f9193e219f24260320accd30ec4501a629"
    sha256 cellar: :any_skip_relocation, big_sur:       "84bbf1f5c23367c0d6e315e9fac1edca589d2cc860553213ce3006c8f2b693ac"
    sha256 cellar: :any_skip_relocation, catalina:      "2b2a6a21556b4b57fa6f19459ae306d267ec0000eeaff8039ef166232a41f9cf"
    sha256 cellar: :any_skip_relocation, mojave:        "ffb4a51e4135be2afe97905ec4add5c769ac9076791a8a1bc71901ba478533f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66268548ee9e2ced59bdc112ae0958f800256279a62c6b0f6389d751c2d2b9f4"
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
