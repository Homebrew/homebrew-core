class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.2",
      revision: "0dc6b1b57dd5bb925d5b03c3d09419ab9fb4225e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "880881dc116c4e1ca446c2ece3a0a04fb0d8263796373cc5e1781e850736d4e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93332d73a70715d1f9aacc57b50d4337f611d91b6e8fd8aa01382592202669f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03205d6f4df1a08c20414c4c151bc1a6738082760a79b9fdd97ad479518234b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2cf0b68e2af58fa48042c87c1f6b7e41d335bfbf8879d0a13c5ebe73fc2489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59c398cc502ec5c1077a041b2253257b957bc9a88d300504b5ec9e566525cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2f1e7a27c88dd4d0c5dcffa453baf50e7931c44818cbcc6d7c251237f48802"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
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
