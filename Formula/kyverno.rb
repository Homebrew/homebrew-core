class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.1",
      revision: "4e1789abb03b316b06d5ca46026709a73c246fea"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ab93305bcc29666f6c2c4e25f12f12cf98a7b8d713ea5e97be3c4a098ee7a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d19a79de6ecde0913c01144afd2fdd4fda07c5c407eeba68c1b598d57f070b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f241d995518ca5c3bd92f238fa7d41d774b596820dc20a88515ad2a526062db0"
    sha256 cellar: :any_skip_relocation, ventura:        "1911849bae7cb55875696f2875df65a818b4ed45336baac16de77f39279a4fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "ae20e0046d938930a0032ef60321c88cb487ef8e8051a9912a3162984f133315"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fb879ff6eda8843d9771f75146982fcbe0d1ee5493332504171b31ef3022647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ccd2fab12a91ff21a1d2efd59e7196c09781b958fbf26037d8496898a67e5ce"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
