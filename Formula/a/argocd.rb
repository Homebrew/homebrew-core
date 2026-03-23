class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.4",
      revision: "34ccdfc3d5235b0184eb910b8ba4edcd81ef8f03"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f2f2506c471940b810d9d6f2ccff146d70042352d5238e31ead79466808b130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b747e649ed80f8bdd8788f4e9b8dd662aaa1698ff944f20d6cde88e9fceda6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2845d6a8e76b17bad09270fddcafb7836948a027ddd03533378f443ba3e452b"
    sha256 cellar: :any_skip_relocation, sonoma:        "082a0391c2e00bbcc4f4b931da7a1a4c54b841761063a7c995d1bebcfe64730e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e70640c2d0d657c85d5d79094d7ea0dbfc95115ceab56ec3b9128aebbed4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9424cea580182daac30623c2076a1aeeb10a2dcddd5367f14ebd746b483288fa"
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
