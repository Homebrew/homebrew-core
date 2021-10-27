class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.1.5",
      revision: "a8a6fc8dda0e26bb1e0b893e270c1128038f5b0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d530b6b768016fa136fb7fdc107709a8c4188af68b91c1886d10f6efac17d6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feedeafe60741c8ed499a91f450b2772ef1d6b27c86673d1807652b9bb6b36e7"
    sha256 cellar: :any_skip_relocation, monterey:       "0d18459693f1e50e4e1516e3fcab2289cf1f222b9d9be4b0f4da6a1ab96fb5f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "58bfa64cffee0c5131ca08b4027a35ae63d0e22e909a14368314865e2687b4bb"
    sha256 cellar: :any_skip_relocation, catalina:       "4d844e4e42f234953cdf782c32f3080a3ccb32b3d538d718fd0bc10d9ca0e392"
    sha256 cellar: :any_skip_relocation, mojave:         "4e920e34167cd5d993256ee6075c6e9efd25519526bb65c4a8cee7cd4f6d88ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61781f163fb32120b8fbf88555076790b5889ef3654b3cf2436cfd8f3067c738"
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
