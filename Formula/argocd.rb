class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.2",
      revision: "6e02f8b23201b0620a4ff1bce5d38229ba1eb02e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ee4579423e7af21eef91141e38b62736b97c233d95b4f843e84957052107e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f94b9336e2d2d04bccecbefb8ef6506ed84a6dca35c28ef64750590bd8726d25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bdb9bbad92d430f898e32e3b04145c88730a4ecbec4cf1272a14da5f020819b"
    sha256 cellar: :any_skip_relocation, ventura:        "18531d8f2c6e0f188eea308097ffe0a457bbfea696bfeab43e0b9890a7c02104"
    sha256 cellar: :any_skip_relocation, monterey:       "fce05e155f5aa1161cf1c3cee8318c270d4f5a5c17b3a0bb110bdd13bdf5434a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9d18ebd4eff239b45776ebe405348a14283edd1168d2ba421acddf819891a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19e1cfab892751084fcfab8223aa446ae05ad34fd18c5f83383b1e7f789b927"
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
