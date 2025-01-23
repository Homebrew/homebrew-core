class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.13.3",
      revision: "a25c8a0eef7830be0c2c9074c92dbea8ff23a962"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d70d5b66095784c0f9320c6e9058d61df2fe8b89e2220e353c0bd3e8bab35a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac7f964f809a4f2bd86f5c2e6fc2b274a141f6515658c44ca48c856d4de10e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "812946513fd9d718e448b3e004cff006e26b054a3d9f34be8a76d2cce514e5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a57205b793c27ab3565be3890c9987afd93d3aafa72e222506dad0ad2f6c6189"
    sha256 cellar: :any_skip_relocation, ventura:       "901bf9f73ab5a7a33945bc7e45f954d3e1f35d9906e2e39bfc319f60ffe7aea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d3baef68223831c44726f202993ae7e5ae958b39b8d37a2dc8b7ed4e4531ec"
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
    system "make", "cli-local"
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
