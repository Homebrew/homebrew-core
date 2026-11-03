class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.7",
      revision: "6d732962f61a99c2a0f221fd26b9aac7c83bcf18"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e99d5d52665feae5feb5d3685dae5b44a3e03ad796d769c0c25902a31fce482e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14be13c87923530b8da071812feb67ccaa5815e59fbf82cd49e19a98c8270593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a6ec470ba59dbdc0a597ac9a44b5a8e2f8d35d1ed449197847d7b4cd9948892"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43e22163360564b468aaf95077b8fd2a109cfd0f71fb61c8b2743b68b372c89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "51731e689093a94b9f1e848247e7c2d4206183c75b09fd5a9dbb51315a130b3f"
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
