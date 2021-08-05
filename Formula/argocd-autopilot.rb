class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.13",
      revision: "41313fecfa12f14bb9b9f0a221ccff5fb3a2bcd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f121c01c526ab5a685f6a4bacdad2bf9918c8a5c50b5c1dfad9e5b7d71bcab9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9dae139c00ff3323ff0b6eb38bf2133761cae7cc097922cd619e1e99b256f5da"
    sha256 cellar: :any_skip_relocation, catalina:      "6935584799f1e40ce90bbc76da99ac4b5664c9dd5884c2cf67050e846bc37651"
    sha256 cellar: :any_skip_relocation, mojave:        "3181cfb27d2fc0896a1d25fe9ab72d2fbe33a466c4e3c6f437472233b78a5262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a96fb3bb40b43ccb1257c145b4749b9edf43bea5ae95abfcf581b76619ab98"
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
