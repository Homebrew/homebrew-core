class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.17",
      revision: "17ffa4b689c320672c0a5c88627d922cc9df7f7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d7122eb815229400b4a303209cc2e11f67a3f1bd3181baaa7cacce6a8cdeeff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b424c0fdaf38d1fd946854932f8dbda270ca802968e0a47762995c42e6957169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec4c1fdc85da245f040cae71900df16a889bd18d64afbd497fd1012f9a0dfd56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4580d5f993ea837766802f8391abdd883cb12149e9d092b2624c48869d6c1eb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8ec329087021b889547ce633df751a1722a1388ab7c46c07db2fd7947db2bdc"
    sha256 cellar: :any_skip_relocation, ventura:        "58df8ae7c89f3ba093c8ecc9ac35720e4eec122aa5a871979189a46e7c8f1339"
    sha256 cellar: :any_skip_relocation, monterey:       "306cbcded6cf64ffe94ed43f1e2bf402fea9a045f2a456914ebc47f6b19b6fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0728147d47d23fea5e23d16ec5b1f15e7f0e0120a1280bbf192d67bbb38a4675"
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
