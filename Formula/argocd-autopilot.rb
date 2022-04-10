class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.2",
      revision: "3f789c814dfd829b2f59d1a0e4941923ac899b81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af4e6acfc818ad7bba44b61b86e2d1da6b8b88875f42eab46bc8eb5a7c74a36a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e427d9206bd94bbf8f8a89d7edf15565ddc9845eac930c36d2af3f33a767a29"
    sha256 cellar: :any_skip_relocation, monterey:       "b69eb96bc80e01ab7288cc8000e32d5825c7f8cbca480fe2d977141b08cf84cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "887e295b5031e094518f8aaee245648946f6bcae12e54a220a8385eb5096a30d"
    sha256 cellar: :any_skip_relocation, catalina:       "aa13166138c1d6e159a80b057f279a706f0ba92e4f901cd6a91aca21979d922d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809e8f6d3f4e8c317c0c994f672d69c707d1cddc8067df40ad31debec5f7e745"
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
