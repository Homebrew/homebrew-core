class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.9",
      revision: "bea2aeb653aba99c12d4351869b2a50e5ab18b98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d249ebb5951a6521a6803444ce40219f6f942c800ae5de025b8601103c07495a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6896a3636bf1b61c210640441791ac95d2f5d760c5e9a0fceb760326ac8a686f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64c48a72984d6d2bc55946f328b7408f82b18def4f189ccead20c506cba3c9f4"
    sha256 cellar: :any_skip_relocation, ventura:        "67bebbff727f657d69541ee169b1257870aa124af286bb5442ee1881bc1d978a"
    sha256 cellar: :any_skip_relocation, monterey:       "5658856b8e1f4b0e9a4e0b6d0c4a3c5232f48f0c35e0fae50cb7c4b6cd6ee86e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eea3050b2903d5e37954ebaa72065164b4accb0c2b12256795d53d433f8c7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bf5fa4d9d3892cf82bad34ee8006fd6de938d3238d5c085445d60a436cb819"
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
