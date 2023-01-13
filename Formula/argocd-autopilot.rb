class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.10",
      revision: "1ce7c092ccb1487b20313aa273568bdd723c785f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f708f5e3b4d57f25a0c185da1dd8851233bad13076a2e3df5a6f4d6193b105d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9397e5e4144887f20a9c9aed4430a9f6973bb4cbec9b66d62c38f8aa15776d08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5ae6c5fd7f465bbe84dc316916b0179e3ec83089f23fb16a4d52f95ab20051"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e9a44718ae1ff3090c50d6435b870108309e96d389e3af3761f9591882a6fa"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd860ced81cfe63237a2c1a63c763257dfdf4d4b0d21105fb7f63816c368f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad50df3215710372eeffff08683f2365f32273696e14e43e699cd1c8009fad97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf880182e2710eb09a314ddffbbbe115a176f12cc77e9a85eab2307455e9989"
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
