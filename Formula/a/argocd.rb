class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.5",
      revision: "564b94973b284b8de98da7cee6eeade2cb941e46"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba7380dd71c30d64d2eac0d67d8f8e7e4cfd90249b5d4d255b9c12877a9828d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49634d8c58be55ad69f4d6273ee20e761f2a76c0aa7ba23d24521b698e4044c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1817875d5ca7780b299639efed911a6662f2d1204ea729e86eba2835316e577d"
    sha256 cellar: :any_skip_relocation, sonoma:        "656472623717efa52b1ec86023d587ff25322952deedbc9e189d6244e283e1bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d44bcb0dd5cedccd410f5a4795b49cbeda097a2a1d3222aa778c8f36b10ae718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc7d10401363016f4797186580363b05f5c994e469408fc64ec4d16a500d82d"
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
