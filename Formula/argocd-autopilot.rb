class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.2",
      revision: "6875c3cec6f58b26e29fdddf86377aacfe63eeff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1af6ae4d0e7b77c9c78ea09960d73c3df20d6c7c13928b092c8991f2963c9e1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "732151964cc3eca0f1c84ce1d2a2419aecb78ef068477e4107488ca65a4bcc32"
    sha256 cellar: :any_skip_relocation, monterey:       "61dc13392319a228b9eeaa7c13376e96f1337dc33287a09858f0a3966f98fd5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "85311f4c74d86c323a7673094aebc904e166d55c420df99a5033935b52c8aaab"
    sha256 cellar: :any_skip_relocation, catalina:       "1ff152c5a1514f318fc65b13e5fc25692b675070601a5051c6624445599d6a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6dcdff8e784ab89ca8b61e413f0b1301f700b127fef9ab6b111810454c4b12e"
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
