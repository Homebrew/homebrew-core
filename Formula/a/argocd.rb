class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.1",
      revision: "8c4ab63a9c72b31d96c6360514cda6254e7e6629"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75f9682726cdf003c70666e6991923f7974407fd59b55ac60bb16d967d177e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6854acd91d2780fb04bbb7cae91942f391210ccc958c562b5e9c6e84e5bd0dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1084e23bf3438730f9a50da7ce28b601e0b02de84f37160414cd7312939bcdf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "53b0cc0abe4b999eade9d954a48dc477687c166239a36bf3fc44ece76b73ec05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d51002cc1c785104637d840a9c73f9f88481a5f6583960397818e1517577687e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7061c57f7240cee7d59d0594bd3ac22f9bf070160efca80fb233d13a2610de"
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
