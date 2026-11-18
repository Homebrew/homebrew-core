class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.6.2",
      revision: "8e8268ef2f3df99ca95663f5080fa6056f156805"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef53a4cfdce846bfec3bd50f1dbf531a51487002f75ffb5c959d1b50c4eb9e7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1f7b79814e10657471a0da506e46849269458fd5ca482257188c013dffb94ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef56710de51983f94cbbb444b40e55a4335e9af98e3178944b9e1185cc3391d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9569c9387867b7b0b45987eae7a13d9c52a8caf3fb3384dfac99cb00c173fa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "905e8cd36c27dabfd560f65b8d6b1b275bcfe3e30503f71e09158526349a6233"
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
