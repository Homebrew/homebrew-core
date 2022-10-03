class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.4.13",
      revision: "19ec34e134cac5e693ddd5f56844a946e6e1d44b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69160e0fb955362f4ba6b0fbe6d28dee91f06428bd20d74c78c7706019dab09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e77d630ab39884f7524b8c5bd2d972ec4b132901e5706f6cb097699ca2150110"
    sha256 cellar: :any_skip_relocation, monterey:       "a45d0f679155f83ddb5b209470ab8195cede1f802d219d03d2e978c1770dc8e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ddb23e2229a2cfac286c8c7520580cd02be836b8c22a585246cb3a84ac17da7"
    sha256 cellar: :any_skip_relocation, catalina:       "4963c55f84f800c0955ffec4c035155c803530e40c9b670addd446e1532877a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4e1b36b9ef8247fbcf8fe19499a97e59f9f083cd1761d80313883daefdb6eae"
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
