class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.9",
      revision: "cc98a8dd0a8e18de026a830c679dfec9c265b0ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43e6c1315e559eb419115a05cf9c3579e624a9b45e56c205c63f5a1682197d78"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3a2501f5cd75499d8cbdd59afbe29a0db29d1ca012507dd85376cf8618606a1"
    sha256 cellar: :any_skip_relocation, catalina:      "e2eb69f81d03a9a2bff5f4a8f818ec885be5f34563923504913e5f0f70104205"
    sha256 cellar: :any_skip_relocation, mojave:        "b015fc7dc6ece7e30b077899ffa4d167903c064923295c86d22aa5658c276513"
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
