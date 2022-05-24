class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.3.4",
      revision: "ac8b7df9467ffcc0920b826c62c4b603a7bfed24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a2061b0992a97ee689bafad95f72371e47b452a6f7593a5742dba5d2531f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b8502d708ebe6fb67e73e63784841376b1168cd774a8c365e5fa4a7c4e690f3"
    sha256 cellar: :any_skip_relocation, monterey:       "e09bf950cc49530751a50bcd391b7f24d583e7cc36d0419945d7483577d12ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "726f692157ee5020354f31d641a4c1bed9fdda9b7e8f9d5f3cc2dad9aa9d0c6b"
    sha256 cellar: :any_skip_relocation, catalina:       "a2c9d4e53a5a05695ee1394e5ef5c8cdcb3bbf699ea677729ba751b9dc3a13d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb9f713e6dd4e6343f7b2c1c5749797b1e1ac840d9d997c77e274fb31dcc37c"
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
