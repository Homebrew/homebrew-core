class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.7.4",
      revision: "d6a72d4412756371b74fa5ef0387b88233a5a19b"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf36fcac529d8aa414fd90caff88f815ecf130922c4f9a14dc469646610c69c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae8aa65eef06389b81e7cea7006ee432e9e1203e8074873ef986916a73578be8"
    sha256 cellar: :any_skip_relocation, monterey:       "38027f78b0f4e8d01b7a846e709a341ca2ac0002e2cf7ebb22611a7b7f1dbf1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dab07a526f3b9d26f1a6b83287c74cca9a90b37d6ffd2e6aa5d72e312eb4c3f2"
    sha256 cellar: :any_skip_relocation, catalina:       "c90deff9e94fb94f53d395be57af1e84da1cd399f675ec9b31ea1457a9681744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6efc654f055319b25b87cef2485daf85df186695112db10f09e616e1a86e2b"
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
