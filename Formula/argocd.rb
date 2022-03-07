class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.0",
      revision: "fe427802293b090f43f91f5839393174df6c3b3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b900b32e8861403240a70a90190cf21062c63d1c05cf2c49a54ce6e97b57e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16c674cd23534d25825d702a629e6694550a3daa176992d4779962009fb8f78"
    sha256 cellar: :any_skip_relocation, monterey:       "4d2cea719df7030ebcae8414f05d0fec9271a0405803d30b015a053f3558fa5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f23b36cf9262652b8f194c0c97b4babd1bb3e5f5b03daa0320abe48ee154ded3"
    sha256 cellar: :any_skip_relocation, catalina:       "6fedcc077a618d3c3c2758d1a5cff26801e82a0fae4effcd7a2d5a1d066c55b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9149e7145db37340ccee01922105c17698276795031a0b66a9d45378234b89"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
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
