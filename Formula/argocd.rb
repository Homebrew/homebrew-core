class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.3",
      revision: "07ac038a8f97a93b401e824550f0505400a8c84e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9d6d379d4a48f29b8571026cf6dc169b9af1c0e321d606fb087ac4b4bce432"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2bfb242508ee231f367a030f3756d59fe055c3082806cdbf70072c77f76478e"
    sha256 cellar: :any_skip_relocation, monterey:       "be39af6af6d7fd332c41d6b62e563669d25d9c433d9c0ce15603a044bb05c27a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db4276adac72c78c35ec851e5837de398e94bc66600503711c8c0c5a1d37e2e"
    sha256 cellar: :any_skip_relocation, catalina:       "13519b9564baae77d7df97b96c378af45a23346db1abe53c3d303bd4ebd93f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3f7a6035058d3fdfdde2f657e5bc5aafeacc0cb821802395a3e342af394e9c"
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
