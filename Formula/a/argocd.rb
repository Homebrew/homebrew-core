class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.14.1",
      revision: "3345d05a43d8edd7ec42ec71ffe8b5f95bc68dbe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d130f267b133fe4271a96ff47cab6f47d3a99f2a0e9ffdedfb91f8c8ffad80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a4786c45300bff0cfd9a6de50bad556a09af2c369a126ca707d6b396c92d27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebaebbcd579811c975ac69f63939aeed66f624a84b1176a2c19de552963e1e77"
    sha256 cellar: :any_skip_relocation, sonoma:        "386b397cfa6ad56c58ad9c05f8d12a5111d0435cc9c31686c5767fd4ec790719"
    sha256 cellar: :any_skip_relocation, ventura:       "df8bdb08bed0073e51bba817ea9639badd92f7336c6fb5cfab63f71f5a47cb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8c9a5e14d80b3e483e61c6568253c978a9c06369fe9b8899f5a7b60fbe91b6"
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
