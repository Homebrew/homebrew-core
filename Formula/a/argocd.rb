class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.12.1",
      revision: "26b2039a55b9bdf807a70d344af8ade5171d3d39"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dbc917227305ddd5d8df6f08ecd271d292b33c2a9b3ad1b13e7d0a2367a524b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b9057bd3addfbbc25fa6c1e0ff47a64b2a4910ce1b527e78cd3eb77a534df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb64a736ca871bc31d59b867dc5cffb37b11f323dc6f1ae68e4d1b805a8a2190"
    sha256 cellar: :any_skip_relocation, sonoma:         "f990a244e3078ad3f59bae9cc3438c4fefa3b9c01a7b5f0a7a47499ec6ba2674"
    sha256 cellar: :any_skip_relocation, ventura:        "a30b793551d802af88ef79d2ab5053fa9d25cf54098aa3d20ae8e10974bd5ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "d7ab20af570a04935f84d4dcd6df039af4ad57ee805eb3f91bcffd21f811be89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473e0221d8fb2b6ac507a459fe5992eb65086e07f7de9b131835633a9bcb6386"
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
