class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.0",
      revision: "c8d17bef976649e4dc2428c14c39e30a0f846552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4667860954fcee008dedd5533dd9a5922e12eb80e7b0c1e4175a98c5b9cacdd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f517892a2b50f7146ee4ee31c8bc663e9cafedfd15e7380eea852af268023466"
    sha256 cellar: :any_skip_relocation, monterey:       "d6f3f69011f806c20e4689b9914eb96c991c8aef5b0537f928249a60e421e884"
    sha256 cellar: :any_skip_relocation, big_sur:        "51ca251e3da8b1886f65091f92d06040aabc320ae635c697f6034fd16e546236"
    sha256 cellar: :any_skip_relocation, catalina:       "931cc914b0a19894968fc6614bad965834493cb4bb39ae44e49909d7fc99eba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ca750d1b68faf70134c2c3251254eee3228a936da02a5eec9f776c58ba6222"
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
