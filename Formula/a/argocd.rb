class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.3",
      revision: "c9c369efcc5b2a0bd720803f8d14a1c3eaddf579"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ca79eeb301ea84df303fde66521718caf414e81218e43f4daf06c65337a76b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de9e6f28938542d270047c50b6fcdb27133fb5f439992dbbd7d7b13406bfd951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a402fb10b53860a41c379fd4585e270522864b0590cb0eab642a200a179e6f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "919f44ae7d9cd64f0c0f9560001c637ab448942d1f42ab343d5e45d0077d0afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "86f261e280e9aba03ab700f7427e92dacf4b69151ff58eded4273eb6853611e9"
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
