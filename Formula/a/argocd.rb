class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.14.3",
      revision: "71fd4e501d0d688ab0d70cd649fbf5f909cff12b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b352e6304a129b6976b708e758e0f1ccf789dcadba4fd8dca42613574662854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e8b8a7ca9d915e77c614445846a08f41172f6d754b4f79d5901d556b5c48cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e78471ed40a7ce160451eba2884da7e89fa103f17284b5a212667c505537fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3425cf11bdb342d3aeed36187aa31842bd642f5605df0ee2b658ed027a1b1521"
    sha256 cellar: :any_skip_relocation, ventura:       "89272e2722256e24d18e4831c1f3c4f7fd48bc33f0207050142956540a1b80ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae579e76fc9e1b7e3ebc2d7d59282c8a52b7a4e4fb2d0cdf29d993050f3cd8df"
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

    generate_completions_from_executable(bin/"argocd", "completion")
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
