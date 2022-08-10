class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.4",
      revision: "8f3d00fa40d89725da61cb1e6259fedcd75bfb27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8bbc7a80e322baa88943d692efbcd45022c6775d843f8c356b9b6a0e9f4865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a39014449ca1d395c189784e6ec44e277db604bfb8de42d68d01efae91d28fc7"
    sha256 cellar: :any_skip_relocation, monterey:       "296270c932212dd2026e5d85e09f57d9b20d620cdf0a66bb04efe4ebe4b9e78b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a655286dfc72cc929c19a6bab2a0a0307383846f018c7239858d6358914beb9b"
    sha256 cellar: :any_skip_relocation, catalina:       "52a4d3bec2c298fc209ec53c127f075988312748640b59bd2fc1f3b112a079a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772b7036ed0605ab9556dea68223d497e32eb7bb71e254f4c5762dc151cad910"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
