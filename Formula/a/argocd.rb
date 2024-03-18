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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57268a71c48e9d12b5c7715c6850c55a583caae071aeb7c8e54fa3d72d225c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48315c1bc1372c0b7db3acaa766881b520edc0aa9c004bd2f0c1671077770c6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d48bde502874e8547dc93a4bb04063aa479ad4bbdd1d33f18d8f9ba38e7247"
    sha256 cellar: :any_skip_relocation, sonoma:         "783b3bf146f87f8ac896772e7d5adae6c1b18da910b544d45f1e5e5e836c0741"
    sha256 cellar: :any_skip_relocation, ventura:        "a0e43755015f0a07b79ada6a13f3f0d72a118b0d1fed7d7f49377acc06bb5873"
    sha256 cellar: :any_skip_relocation, monterey:       "3e40fdd84c33ba09c41185312c01b284cc50feb5bd7201eaff3c4b25afcb1eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170b7296a25c9034a503192ff77cae09d37e91d20d339affc2b0b9b7975a9f9b"
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
