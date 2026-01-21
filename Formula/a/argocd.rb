class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.5",
      revision: "c56f4400f22c7e9fe9c5c12b85576b74369fb6b8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1397927511bcdb67caa29a3125c5d8a65808c3ddfb3485d99061f51a412b39c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14526050e22af61863143cf2ac522ee172ee1d07638dd3444f1a325d9941078e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d2b06c3e8ba2982cd16812fdc73fe1c0deacc7b0c12d112ab025e0f8069e44"
    sha256 cellar: :any_skip_relocation, sonoma:        "043ef3e7b3ba179fa092a399773e6f243a5265cde9e37c03f85e3e711e90b9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0e5afce1094456d9125976d07c85467b64ee34045fc887612b85ca74307796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186a52feda8a9069afcd71bbed9f1c371fffdd6d1230900b8bfd9cefb2946a08"
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
