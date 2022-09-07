class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.6",
      revision: "534f514aedf439157aa1079e92b74ac6c0fb3991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3623c71b7b158d25ccacf19d96241435ed916dd13528b21fc26e3b812e8bf5a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a24c8280dae621da50438819d83e58838911006e41f33fc353816e01c77a15"
    sha256 cellar: :any_skip_relocation, monterey:       "5e664c661f346838ada91e1fe7024725cb56c4c24d17704cc6ac364eda369c2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d85c8375d099730707a0715db19c1d171ab786af1bc6316dac06c8898cb23e77"
    sha256 cellar: :any_skip_relocation, catalina:       "f79c970bfb24536e77b203c54369ecdb0067f87acedec8d99983900c3635ab29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0b9556515fc44f8612735fb92f14b1c1abc0df85ea2d1c1962c95e3bf932d9"
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
