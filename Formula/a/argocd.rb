class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.1",
      revision: "bafd59bd37138ed731d3c3aad8e18731d72aed46"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9255df40f14fb299d98d43cec3c61cc9cd946bc84abf0c6c533120633962c78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0bacf07d8fcd4e9529a4f3026cb0fe64123143baa4172529c9d93a1cb10390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd446dee110d6db7ac22ac55c4a4f1f67ff659f30bf26309856f7fe5b5a04e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a944b1bbef03f8586c500e2c1f5966189ddab0ee37bedfb32f4ecfadbd70e5e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b6db946befb00ce0ee97d9e5d03c21238072a4a2148104f5958ee38ac981cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9ef8931907f0f6665f667ecb650d31065e2a868025eb4ed51df0eb832db1f8"
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
