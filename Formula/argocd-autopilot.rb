class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.21",
      revision: "bf01ca1f4d1492e47fcff4011d9a1acf138edd7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "287c1a8d00d99b3e8e8454f2442639d23dec6830c6bee614bc38984f5cf9763f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9973d9374b45faf2385e3cdac0e4f2d4202342adf9c5c4f0932e0622ec5faba"
    sha256 cellar: :any_skip_relocation, catalina:      "36d22136e182a586ff3024d518bac5712669550977e2fdae7cf86a36ffc51efd"
    sha256 cellar: :any_skip_relocation, mojave:        "b05eeb5a332ea2541da04ce39e48a29efa9951c9a02b0ad18bb8d15087ae1813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c9c4602203e1128c6be6280cca2a6513d77a80765a221091b20e509f6eebab"
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
