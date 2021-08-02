class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.13",
      revision: "41313fecfa12f14bb9b9f0a221ccff5fb3a2bcd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc15eb5a19d114362934934f48a0b8d0df42c238ab95647a6a3e4ebc88817d8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b9b0e7b93a7874759fadeda7c9afc61e713fdab8723df9c70a82bf2ade6479d"
    sha256 cellar: :any_skip_relocation, catalina:      "2cca6b73536fbcc7e118cdf35999f8c7ea180ad5fb8d333e1c930e70d90c1402"
    sha256 cellar: :any_skip_relocation, mojave:        "cf77d5875c35d107f3e24b3b7b48569abb0204f6ff0c4c4153242cfca73a7f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485d945bc69313d5bf5b7eff1f612d58c0798f3f1b861baf1b1d6ca274bc34fb"
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
