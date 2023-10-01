class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.16",
      revision: "66a80dd5eba50de13f10eccd1fb29ca124ef3c2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8181b8f0038c129fb4348a87f34f28e10b89df318f64f1cfb8a566fc78733ca2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3890458cb1741931fed1c90807c8998f6527d4dad22248142e6c3e7bc1175d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdbc2c016d918277e70b93a441d5f524d57fa4a9ceb4f7a6f58abd652905210d"
    sha256 cellar: :any_skip_relocation, ventura:        "214adfa414e0f385dc5887c9680355eb7657a80ca4124ca5af3fc37bf096c37b"
    sha256 cellar: :any_skip_relocation, monterey:       "5e9b2953f7376eb6601a21ba49fc1bcea4d8286054ee2e06274c2b18138fcee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "edb7571c2730307ddf189a08b438221947095bcda93f4cfa979bcf8c4de50f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c7911af96f851221ebb632af2762163b20917675684724a9e25f300801639d"
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
