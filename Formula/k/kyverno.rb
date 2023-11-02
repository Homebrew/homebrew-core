class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.10.4",
      revision: "da6ef87588b7c14a9f01af80b461973494b422fd"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4ff4b9f58fec8cb73d570bd1a907d344d4f27461551ed75a365756048ebf6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f73167aea51b908219cca0b90f8cc775e30ad21b0856c44754767e9f52fe301e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3c62a4cd76f0fa771d69d9cc94ae09cd269fe917dca6539dcee05a67e93be73"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b3f4338e6e55011f75f3e509744d26ac4ae03388fbeaa7921fd517c1fd0ddd0"
    sha256 cellar: :any_skip_relocation, ventura:        "1f399638e720bb576d0053ef91287cf5665444c33b91d3038f45eb1d7626832c"
    sha256 cellar: :any_skip_relocation, monterey:       "c182c4ac2956c8d4a3c79dfb50f5d3bd733616a05a4b608e0fa3413639579b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f68d2c4357d8eaa81789fc24eb6f44e780ae81c1f46104ee012e96af40b09c0"
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
