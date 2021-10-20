class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.23",
      revision: "21ea2d79d20e1081e8db883a608fffa175372374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57a02ccc80d8474204520dd0c948b3ed94f7e05bb3625e8edf6d5137350f13e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "dff33d8884d53f4735e768b0ae3bcd66bf903416921b2a6b088868e5154d8ece"
    sha256 cellar: :any_skip_relocation, catalina:      "b8ed08fdb55b9298a5bbd1f85cf346fa34215d6f6d7868bdd4e13d3e3142d5ae"
    sha256 cellar: :any_skip_relocation, mojave:        "263ac8b587be7ad5ad7b2033d76690d3e851871abac257ff924a5c4eda636770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45252bdeb910fa528522880b9c950682001b4a4819b1d21f0c252174d943957"
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
