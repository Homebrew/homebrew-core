class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "32c7451f768280a8a1199be1b595ccd3847e196da0b04a33076af83d07737e88"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e9304423f6c9de6798782616e08a732d9983bee5b6fcb2d4194dabeb5e847c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69a6d26a6cf6e5ac4c170f86d9ee0bda56cfc9bf985025972ece51b005f4565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3874e0d5e30db6e8f3d4edfe57dd23075f0281cc40eac1677307a95bb2e5c35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1223c1458893e9d7dafa136a75423d2e3544de85c331c5e9a08f0c1c98807b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f44084feb208336733d1971941c13f0565cf101c81f8b201ef1d3408e46757e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5e4c51e3e383278b6ec0b73af56d8feba0ddcc3a88d7ec8ff8ad2c11ac277d"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
