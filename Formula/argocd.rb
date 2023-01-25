class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.8",
      revision: "bbe870ff5904dd1cebeba6c5dcb7129ce7c2b5e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e09f89f6122caeac8d6304bc69f195bd68fa792c82f495474839802e59058b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c12f3251beb2c13773b6d01f00001dda54c5264cd9dd1e8b6f0e2bb31c93a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5725c13f9426a8e7edccc0b922d8d3d038fbf1d368bee369ecbbae1635ee2c61"
    sha256 cellar: :any_skip_relocation, ventura:        "2ec0771fcd49aeab4689c2f6582d7006da0d10abd613ee2e06f4593e047ec4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0dc5e1316d5ccb88e1c81c28cd2a6779d098eac470438f95af161e3becb80e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c334c288c47a764d170ac2f3c34e98919ef3db313dc98f7638487159e82fac5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91fa7b5a4ff0de676bc93b5b963ac84f3be9a7d4ca2f7024c8dc3d5da2816ac"
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
