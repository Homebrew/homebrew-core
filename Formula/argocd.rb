class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.5",
      revision: "60104aca6faec73d10d57cb38245d47f4fb3146b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "573bdeb2fbb4439cb659d271b27b1de9c70737e9102a0de1e90837d0d59aa1f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7853208bf5dbe5380d833970753440a73841ad441d8a7e88ed1ed716fa6310f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb081dd4ea93a770c5b060594c07f6dde4dee3a6410354642405a5d765fea67"
    sha256 cellar: :any_skip_relocation, ventura:        "e74a920623fc6f6c30366a2337bb1fc8e639c3b230a4e85bca9487e4b7617e32"
    sha256 cellar: :any_skip_relocation, monterey:       "770b0f988af9cd9ebcf0bd0b4b27c4a3c3c31cbd8bbffe3626bed9672a7cbcd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e748ddaae3fc9af1a0c1c24a19195e3a7c030b5974055b20749d931dedc892ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7ad2cbefd317d294384e5ef6c6c555f00307a1dc28906381361bc4002c58a4b"
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
