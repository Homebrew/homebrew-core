class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.12.4",
      revision: "27d1e641b6ea99d9f4bf788c032aeaeefd782910"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d945e81cc454c66c8b066bbd96a7f7e8337d488223663dafa369fd23779312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39c289492875fac7e77134febaf9938c74899bc92328488f4c7e6b5662447c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfe85d53371a603507bc5ee184a83f199f863e260658706731359da31dad20c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bfd55e4faf3c2d4b2f83b51f3a9465a9b97f157b7f75c5f06ac969c8315ed6b"
    sha256 cellar: :any_skip_relocation, ventura:       "aec3fe067d85c71600fcf768d3dbbf4995deb61ceaa60b0a2c87a3e0a0120a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc692fb3e9615f2fc63487df78406101115ad139402c22cdb8a5183a61184dd1"
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
