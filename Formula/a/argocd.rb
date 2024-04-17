class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.10.7",
      revision: "b060053b099b4c81c1e635839a309c9c8c1863e9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72cb42f59a6349905730f88690851aa6a3e64503ba5b8ce952691c5226bde14f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e517272fe4092e0de1afbbb31e974b2427c781a65a1504857389a174d4df3bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73677fac9c13f180454d1e65b77bb2c192852feb012f3df2938cfabb4267e58"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0b6470264c1d6cd1c9a4575fca52a3aa47aacd08ba62e49e923e5e24f4320e0"
    sha256 cellar: :any_skip_relocation, ventura:        "52763ed3f8b91b8e840e21fd5373317e7c559ee70175ff5edf0c62b3c40f0938"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c693276047a46d0f62398afa3c2ab18883a988afdbcc0b62e5e822a0bbbeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21f7b8c51576892b68c96f55e9973872ac9a58796db2392d3ffa5484632f1e4"
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
