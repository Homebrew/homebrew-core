class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.10.1",
      revision: "a79e0eaca415461dc36615470cecc25d6d38cefb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d6b7e605bf3ad84dd34282749f255bf2ad99e7a04e709ad8442fbee3064967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e20e9fa5694d96d1f39072692acb9a6d9c4e232134a3c04c34e9b73bf4434895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1285420081869a12b55a9e8a13a851b59fe4fd2dd34f2f12173b7cf4734a12e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7af84b2643f8380b0633a9f69578ea6b2bcd04de2bb43afc0955116b2389b07"
    sha256 cellar: :any_skip_relocation, ventura:        "cc50d5607514200f200be774a51b268fa841f47350d4dd86b2ffa095e6c0e915"
    sha256 cellar: :any_skip_relocation, monterey:       "1e14c8db03579567c78197ba451d7587aade690f772d73795c751243ad215fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4ff770948ed87d2a6942c08a30129d330cc761be391f71867097a4a7c3e123"
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

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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
