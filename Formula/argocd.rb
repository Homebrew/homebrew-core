class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.2",
      revision: "148d8da7a996f6c9f4d102fdd8e688c2ff3fd8c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aabd710228bbefef3fc8517ad1c28d4505e6579740a40454421062fb33e4ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e50f65b0f38b9d124c0f6bc49544aa2dbd5265e3823ad90355fa18ea742ad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db46f65a509fd980120e1410bae5a4c4fded3a71223c37798bf55ce8b80a6372"
    sha256 cellar: :any_skip_relocation, ventura:        "7291112a9879e3b5fd15e9e2e448cce9ebdefe2751a265e1768883b943f50939"
    sha256 cellar: :any_skip_relocation, monterey:       "021d508f4cd8d0208c4ea0ba1f493ba337950136d914f98d4933872e5aa6c7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f33d2a51399ac0b35ce549f3996ffa220ab61e087e1798e374e97b6977cbbe72"
    sha256 cellar: :any_skip_relocation, catalina:       "02c99c100608a5b02a3e4ea153001c8f50fe936d14832d117f08c52fc0e241f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d709a1b7e322b6a6e2399abeab3e98230668be8c2d8e291bd481cb1e49f0ac"
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
