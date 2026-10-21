class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.6",
      revision: "c2b1e3017e2cec86b122172e861dcd026453ae44"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c55b3a992867150fbf98383074822cbb0fdec9b811f0fc8094d028794fc1be02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d928f0f509d616095568ffe38e0be3bcea41701d0c2a9b8a914fb551d4419ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3daf558c0f4ad26883a82f10de4ce3d5f1dc4756432d255b12be057bf4af74a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb56414a1e21974d810ddcd308ac504c1da5f3443029012f957fb1cd5bb3a5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55cad9bc0514284626e0583d5447ae77ce0e1fa3b27ee98d3fc344823a3bbeba"
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
