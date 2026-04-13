class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.6",
      revision: "998fb59dc355653c0657908a6ea2f87136e022d1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "415b42413303eef770cecaee3dfb3bc6d885bdf328e86be4384592c943466944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c817d0a4bb59f01e7a9513a244c1ede2b326563d4c2e28d8b24ebf77b1dd1fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc17b08d2d3decb8d515f67f36070926f764a8d02a17776bea5e5548ffcb145"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed754aff4efc0d8dbb122a80ad2b16727828b312295f0f92576577a35acd9963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41afb4a4c05b255d0166fa95c515c913d13fa96a4c81f597c61eaa294094e1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b886119d53563cb68a35b596d76c5755b30ff3a0959211904b127113693c81"
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
