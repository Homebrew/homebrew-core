class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.11.0",
      revision: "d3f33c00197e7f1d16f2a73ce1aeced464b07175"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fba84cccea70e633ab007250791e6d26178635a7c5f1299ef1976aefdcb98ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fefe5a5c11fb1bd5168998d0900a99d0e6dcbd25516750a8354fe641f1243d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e680365f38a824e2f601bf85c2bb510d5e38926d97c2517c6d9e8c3b62d0cfb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d377fda2ff77f54b9b07e7d991a51f1fa33b721fe14193544960dd0cad7cbd"
    sha256 cellar: :any_skip_relocation, ventura:        "9fef6d3e112cba6f4848f758f870156068d313e8b628810825d86e8379f27248"
    sha256 cellar: :any_skip_relocation, monterey:       "ce05a09e3b7cc830cfce09fee4b9b51233a5c6bd0f0caca52a9a2c1490be520f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef97c153271e13f1a6c40e01b4bc4fee8a0e3c16016e50a0686dda310ef59568"
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
