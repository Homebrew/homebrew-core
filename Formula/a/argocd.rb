class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.6.0",
      revision: "f55566445ee3a2a4f3339bf10df0f6bc1ecf7f23"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ffccf4b6303610bf9b4f3deb57c7fb0b337f2f16331d39130e1851b426db2ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03da0d3b880db18d131fca2d2920ed3c732af27c579e18b69ed59b4f0311fa73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9f8b368b16a0370614b480b9219059e2145f118c80833c7602aaeca26d1904c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04373e0a7c07d0af818e8d7b4083dce93f54eab21f8aa84af85a0c29b3a7b098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "868d0f562b04975771483fbae8e4819a18ac1c79885020049032e216d0186f73"
  end

  depends_on "corepack" => :build # requires newer `yarn`
  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "go", "mod", "download"
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile"
    end
  end

  def install
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      cd "ui" do
        system "pnpm", "run", "build"
      end
    end
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls an Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
