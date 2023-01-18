class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.7",
      revision: "e0ee3458d0921ad636c5977d96873d18590ecf1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d562d71f15e3dd7da44b5d9c70277d44fd531c29e37f4989f2104e9c55a51ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "945371241f06cf6d952fc661cf2deebeebcf426e8b43c53cfe3991825155b595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d2b439b2a6025487eab88bbc97ab7aa19517590083f6a30f13dc8c1fd83e88f"
    sha256 cellar: :any_skip_relocation, ventura:        "2a7c1a2d0e5a1064609ae814560c1673887c9575275527b38755e921c83e7f26"
    sha256 cellar: :any_skip_relocation, monterey:       "93d468b00a119494d1ba9064d3d99b3103e114acc8c7743578a3050dc0e6a323"
    sha256 cellar: :any_skip_relocation, big_sur:        "6305603cd211c6d260651ab8772af3398604ff35a01c64f90f4b30ee0c3bbd26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "defd4eb39322a2c6d819d533a48d764aa30994b1c728e28a4e628d0bd669fe13"
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
