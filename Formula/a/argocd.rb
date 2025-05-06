class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.0.0",
      revision: "e98f483bfd5781df2592fef1aeed1148f150d9c9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca3fb20a827126bd838f770760216c30b861c85234135a7ed80f1c23180029e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade4b36a0e0605db1222500fb21289e2d450c7becab7ac6a4d8c1d25f83c235d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35d721b01ed5f3750d26d9a5608fdc1d804b2520cb90190c28ee450636306237"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b9ccf98d896a8c639dc033b7bb2db32f406001d88435a02aeb647a1e646188"
    sha256 cellar: :any_skip_relocation, ventura:       "f45316fcb3b341da206798a189431ec0093ebaf222bc58f5a27a7af91646bc31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fdbae4a0114de3119375df720779a2559fe589e7459860c1857b7be36c7bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff60d3bc2fe205c16e58966bdfa87c270e514217b0b42fe1cccf4378a2deb7f"
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
