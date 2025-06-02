class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.0.5",
      revision: "af9ebac0bb35dc16eb034c1cefaf7c92d1029927"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc11a2134d311e9aff59b361794c9fa12b6259bb7e29032c52d3a6d1faa1a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df04d37a35a1b04e6c503f23bf01c5dae895a343dc99a5f35d1ab87b561ff09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8957553bf5928aa80604632ac8c68c33fbffb69c85eeffa0f957b095cbc77cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6150f0a31481f178cddd22ac71165db9237a63cc205336c9f8bad0fec8b638"
    sha256 cellar: :any_skip_relocation, ventura:       "cf818311d8b27752d0d07b894681d5883cd28c5242402546b181174b2c3d9c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474106dc5e29ba5c2e4d2be53223147c4206779ac81314e77d0ceb3469aaef30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aae9b41600b0dded58979a15dd6f7648b305a0c9c2aca00392cf5790b3a9fa9"
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
