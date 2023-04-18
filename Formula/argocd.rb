class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.7",
      revision: "5bcd846fa16e4b19d8f477de7da50ec0aef320e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a3a22dc1f193cbd2eea83289e9e5d686ce462d0560541d4f317d10f345091bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5128207a54c228dd02929a3a57ac3a1952b033105cf475ff56834b753b838c30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee36ee9f32c9d5d35af385dfff722058ecdde194ab85c5131b7c2750e2f679f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b09624aff217db8fa8001f51e47c0f2bd420cf1cdf6c4c0ccdb58d6992424877"
    sha256 cellar: :any_skip_relocation, monterey:       "e312c23d55f90131b692d114e04ca16a5bc2036be0484c813452911b560e32f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "890d84a310931794a2037545bfb2a59e1d93c649721a2a66a8549b41f4874c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27cb717d520126ecdc764083bfa1191c90cda49ce59b9499f21363d471dde0e5"
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
