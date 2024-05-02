class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.10.9",
      revision: "c071af808170bfc39cbdf6b9be4d0212dd66db0c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c747a04bb8142b3f17eee07a15d0bc5a93df08784ce288aa8500df0c9d906073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ce7124bf45c77e60e9eb87126d72bc6b8a1312ae3b6faec1f0be982680a67b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf827a451d76dd5f83b318e02868b129abdb0afca4f2be0d51a9ad30808e0eac"
    sha256 cellar: :any_skip_relocation, sonoma:         "455ba8def2c7537b68a00795799229a11c9dfed68c22a62db9994159ca0c239e"
    sha256 cellar: :any_skip_relocation, ventura:        "2caa6adf36ce1fdc23954941efcd3193c73f031f5914e000f824a02eb53cf11e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6b7da16cfa5aec4ba401d1f2370f3afe80e7e9180b4fe22470dace1b2abbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "573989d916348e61a5c48761d15bb76eb61bc2b88814e8e72726bb76c08066d1"
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
