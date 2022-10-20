class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.8.0",
      revision: "957a6bc543aa30017b0695eae5a63ded8fe91a32"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c6f06c98d69883cdb27bae7c2c6f8bde6f1adc40805f3a98dba369c4c42a11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f9c63f99239e4b7f5838e3c6cf9353e1b2c6a9e4b91dd8090d8b42b8898b4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a5eafda966990d7624f764426e95eaca3e086471e4d5b3ad108d0807143e130b"
    sha256 cellar: :any_skip_relocation, big_sur:        "47e8489e1204f9705d4b1a0a9fc9e5df8884a7e61a0059fc58b62ca3596ce523"
    sha256 cellar: :any_skip_relocation, catalina:       "90712c082cf1ea4d3b94a3512c13e24d3df76be88db3df032ff48a72377f8cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d92fe269978b12c39eb15696ef4e65d369b17b6f2bdd397ef38e7ed2351d03"
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
