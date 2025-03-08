class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.14.4",
      revision: "3d901f2037888af302a85f518bea70b33ee8e1c7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa95c90f135995b4b162f8993384b4ab2b56f0587986128d002998b120bb88c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94ab48e7833799fd2105111ac53f2d6e4c306f73d76f1c6aab8988c7cdaa336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2e083216df5da38cb954932eb4a34d772934a83dbc9621bc9fe31f481b5be11"
    sha256 cellar: :any_skip_relocation, sonoma:        "c414dfc1fad922e03faa4b20f6e8b29b83cab3b1bb0f09ffefc57373ebcc97cf"
    sha256 cellar: :any_skip_relocation, ventura:       "ca1cb3cca547f66790bcbc2081f9a28e6bdc1c045511c7b49db07e46714330c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0add0846043651c0cbffe553ebcfbc45308e48b93bfefd642508ddcee9638dff"
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
