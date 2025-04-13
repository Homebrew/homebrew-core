class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.14.9",
      revision: "38985bdcd6c3b031fb83757a1fb0c39a55bf6a24"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60f591e2c01014dd155dcedaf2015ad4fe18292a1af42bfaacd5ab5b6e1072a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13e2e8ea98f3ae109fe39f59b454af9a34e1c3c8c0c9de2234a8014df22b94e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "142175ae418a2cad565c5976256bea4cdde5e76405a0b66f7e221b98141bf556"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1fa72d2d93e5935c9263d5d6e93a9f4a7bfc5f151b20d19d09f738855edda3a"
    sha256 cellar: :any_skip_relocation, ventura:       "aebd058695312fd7351baf6b3b1eb76fac9871da8882545b1d2d71c6c3fd7f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55530466399b874b64ccb57fb08bf0a25dd30657c7d0ce7e12712952fc40972a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d326f8fbf05ec4f3ee64a1715ba2e8bd2277bc93bde34e79cad26d8dd18eb3b3"
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
