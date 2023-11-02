class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.6",
      revision: "6f7af53bea9ebc9e9eadd47fc43b671ef91c0586"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "507d3e3df23cb325f9d7f51ff25ed1364079e6505f4b281dfa1dc7fc9bfff6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9178447fa3e02f7d53b7696e9541427a8a04742619b6332197e100c836cb5e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba36237a1df5d2cacabcf862c7f62818ef495c43dd1f73f999b5f8a66955c34"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a337d775d8ebee6d4c527431d96f697b5d73a4f3ae835e4bab81e684099bb0"
    sha256 cellar: :any_skip_relocation, ventura:        "945a4c4b813cd156cfed7340463c2c4b53e1ead273ffc66d0e67c0b289347c07"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0c146c2ddb76a1a9a42def725db10f3e8a57eaf67b65dc9b77ae4e4656d490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1fc4b5689cb7603a65b849d07d3a108d6285f3cd1aa864980ea6128afe449c"
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
