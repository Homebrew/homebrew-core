class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.15",
      revision: "05acf7a52e377eacfee29c68e3e5e79a172ea013"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f95ac8f8758dea2825da084306d173c26b26352cecec15a91d7310737cfaa25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c14c74669ac9acc60687f2a21b4921438b06e46fc33e329e3f2794f75f430c3"
    sha256 cellar: :any_skip_relocation, monterey:       "fee5415325821d211f8d03309cc5df10f435dbc60c2d6e152c29106370b0dbe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d621a5623cb429261c35bbde0ac9dd6dc0aa07ff587bf7f129bef6e2f5116fe"
    sha256 cellar: :any_skip_relocation, catalina:       "6b4a889de2e51dc3f68a2a98984257c9e0cbc7dac50e9335f5a3b2e1cc7713df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0ca3259e01ba741622d396e157640246668b3cb81da55605775bf3e1435f1e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
