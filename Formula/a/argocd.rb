class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.12.6",
      revision: "4dab5bd6a60adea12e084ad23519e35b710060a2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9f7501c3fb734c9bf26fa767656995f1b5ff5a29767818ed8db505c678da153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa0aa47655425a9ee66aaee9a292d6bbdc9405bef8b83582572ab95caeea31d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c2d8e3213ac3855a6a18ce5ac6eb40271854876042d26269f5ae4c8ba82ed94"
    sha256 cellar: :any_skip_relocation, sonoma:        "5acfd507e704cc800c14a027d1d29e49d37c39b67a644da1ad3bc8a592286ab4"
    sha256 cellar: :any_skip_relocation, ventura:       "6d5a7f308953c562426c22cdefe50ddfc567b7a1dd460ca708b60d9a034490ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4587c65059df00455593995eeae5d2bd2b92ce0524f98a519d129a9137dccba"
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
