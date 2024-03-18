class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.10.4",
      revision: "f5d63a5c77d2e804e51ef94bee3db441e0789d00"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecabe220793ccc1afc43ac618061d59633c6c78c0be741dd44a9f5cade59c7cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abd299b201526e92dacaff9661bf0f8c0c29dd8e2373927506bdd651fc735d8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41523069408e6fa55eda9a6282ecfc25ce515d6af7f2aa17e55d4fa327095d53"
    sha256 cellar: :any_skip_relocation, sonoma:         "79fab8a0d41ab80b2045fe8dc91af0fd459bf799c727d38c692fb491ad82d4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "d62d60a0f39e24b2ab1ae4ddff9587d68bdcd4cb13c58785e6e151c89c8c0db3"
    sha256 cellar: :any_skip_relocation, monterey:       "625a1f7acbdf487eaddb4731d617dba6babfd67cb4812cc219e770754e60f2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937050e69fb575b62a925ff10170543625cfc5f79854d7dffd9872013663c71c"
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
