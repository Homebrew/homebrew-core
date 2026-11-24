class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.6.3",
      revision: "b4accc482028fd529b3e4508ef9f28977b552b50"
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
    manifest_sha256 "7490954117698d7e394999cf4d5cc3b6c6a5589c97a14d2911a09223f04898fa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f1bf9786619c2d78ff45fffe03b1e851f5cc44b0f674f6f1df13625cbb4776c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7de21b8e7ec9fb9289cc091613bff5778b8969d42f1d83ade85a5ea334f4aeae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6821d806dc71e9f9bdaf343c52cae34f987bbd858b2e051a2a67f84a1968f5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2839a7752d8272f13d47b937749ee011a8f0bd792141c8bd4d9e399b51a57473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ce74869a0cbe60528e05ce7475bb9cbeeb5920effd0945fd1f9a61678f148b3"
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
