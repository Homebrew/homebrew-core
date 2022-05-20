class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.7",
      revision: "9ba4ca5f5b489bd8f30a3f017a745d2863af795b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e48fce2893d5d68863f94ec8520bb511db5e8611ac5d7ff5647f2b11305edf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553860f88e2c4324f3cffe1d027f5d55eb98528458f51b1271782ce3f0b262a9"
    sha256 cellar: :any_skip_relocation, monterey:       "960be71469df0163c447be0f00e604d6c3211f7efa15f1650a6b362656db4469"
    sha256 cellar: :any_skip_relocation, big_sur:        "708601d9b4faf2b64981956e9cf32715a5494683440785ff047875a616bb0e93"
    sha256 cellar: :any_skip_relocation, catalina:       "fd22d8ca571c4523f6c3988084c20224d4a989b4bf007f6b9b7c919c7536099a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c03a0f448fd62ba2f18ec0a974d13fcbfe18562e4b165667fa4babda8272d82"
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
