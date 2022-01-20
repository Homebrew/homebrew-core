class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.3",
      revision: "987f6659b88e656a8f6f8feef87f4dd467d53c44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de469fcd14b4d01ad4a3ab6599e400587d674b4eb09a52fad811374ddcab16c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "125454fe29c8c4f4a3406c5cbe631d4f9c3164894737bb7f2bb44423b76c41a9"
    sha256 cellar: :any_skip_relocation, monterey:       "3155751b4db275587d904ecd90f55c5557db984fe9e57864725e796317f7b214"
    sha256 cellar: :any_skip_relocation, big_sur:        "aebc1b6acb5f729aac1e9110c949220f5bb6a019882d3aa7daed8628419e782c"
    sha256 cellar: :any_skip_relocation, catalina:       "d214fb349371ae3ad155644be33237014cab1c07adb655051efec1d4ca93a770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f7f72969c162d5d9ef248c74861b438e230d8843ea742d351ecb1c7d857da57"
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
