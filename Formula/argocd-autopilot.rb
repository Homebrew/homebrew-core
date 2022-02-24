class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.29",
      revision: "f87e111830545869e60c96adef6da6a989e51a4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20cb17039f9a6c2133948d27de0833dcfe24d982a0c2fb799c7afa75192050c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "019d60fc99627ebd50a608ffd2b88bd81b15fc799c7cb686b87a3700bc2de223"
    sha256 cellar: :any_skip_relocation, monterey:       "81e436dffba1ad62006183d248e8becc6ab115f002c9cbc2c380ee9a6383eb40"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd6486c5e80a77b8b59c10070ce75fea8efcf938fab62e733543aafd1ac5a1ff"
    sha256 cellar: :any_skip_relocation, catalina:       "f8d20a5e778152477180d73ff0762c4fe53b03e65b08f9736d2c85687dfa9347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720554bb42dded67408d4b27ae2f745896e9c554ab6d6f6619f2a506067d6c47"
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
