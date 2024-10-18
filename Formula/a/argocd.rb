class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.12.5",
      revision: "85be9a4f22981ac18b3b0438f4df84f36ea32236"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55a1c3302492033113faaf15397c858ad9969f4d1402813034e0a53c8e1c9c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01dcf40b277b74aec9a42338491bee6f36e3d1d77ad8103f5aefea05ffb5ecfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb6bcc830394a713bfb76a6ad9136d31387d8dff271a942ceeb1ac333f407899"
    sha256 cellar: :any_skip_relocation, sonoma:        "77dc24dacbf983c91ef8fd4a460c07abf65b968e2d3c2cd01cc5db5155de6419"
    sha256 cellar: :any_skip_relocation, ventura:       "de11e0a9dff8429537f40ba12e251e5f7ad3f9b2a36193052213bd75174ac0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5abb2b116f0aca12eee6b06e820c56c0302f4a942aaedf21f103ca8eed22e3"
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
