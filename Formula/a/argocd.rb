class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.6.1",
      revision: "94037c4d4e1af4bd0651d37a179fbd9e347e668c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "002eeae846baaf6d943b038f439e057376552ff611b122e891bc9b44c95bc047"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f087b72a2e56038af45e4c70d6a7e79eccd416d3f42adb89f7fc33597a12e118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e965eb37bf1938406a9bd702cfa962920722f432fcd28cc6cedafa3d1675dc08"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9949386a7fb7e3d3ffd539f2bb6e80e9bb3cec389da75c224da2f3068f148f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4843be417ea5c1e3d03529870ed2a4988e65ff3e7351ab9e771880834ab3f43f"
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
