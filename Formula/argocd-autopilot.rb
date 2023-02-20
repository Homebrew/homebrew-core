class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.12",
      revision: "472c6a0f828841ab8c20959bf0fe72df2d6f2093"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e3e7ce742d340add65e38f4ece4217d269b64980b631abfd397643d325ad1f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca41665b4207a2307350055495da086e57e39d5822316fc8ccec02838cdd0f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37aaf371ef41179bcfc1007f4cd9f01522c94a19b1143cef3153564edbfd61e4"
    sha256 cellar: :any_skip_relocation, ventura:        "a5db3af8c51e54e63efda1c2c4c504e3d32c0807659bfe49b4afa2ff52668b07"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8d56e36644a1bb804faec100f190c0792f0fd064912962dc0fffaacea121fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2cf2fdbf46d4b0675794c2cb3f92a8f9986c09e5b5dc12f75c79b572bdb2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76e274019d5057320c71599649df1569771b439243260c1ecdaa806e8f01b3e"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
