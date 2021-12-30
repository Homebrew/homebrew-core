class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.28",
      revision: "79270a4698b4d648861483eefa71f981188d3f00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6020b6e6f24c6a6ed907e795904de487b7c4cd70a955592bc5e7dd1cac2d7757"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc3d08a86c2556bdfb347acb144a1329a9a810169f3b6f7d0b48fb4ba7c4abc4"
    sha256 cellar: :any_skip_relocation, monterey:       "032d5d00985b5a59552eab31c29b71eeef65965aa65bc3b590f40a4572cb3338"
    sha256 cellar: :any_skip_relocation, big_sur:        "b36998cad92d5b2fedff4d84615a0ab0c01d553eaab65cee6113009896d76839"
    sha256 cellar: :any_skip_relocation, catalina:       "e1516e3605302b6c8f8bb9ffb4c0f4a5a1c79798beaa7145e7650ffbe40a16e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6574422ada87fec6ad164ad5980323852707dd61774bebf867c3941e66c855"
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
