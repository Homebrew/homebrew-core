class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "92daf7aa0cc283a86402f722879693cf1467d008ef9c2d2e77d6977d615835cb"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97df955ad2cdd89672e0ac1be7f43d04e5706c09118bbdb0fa6f7cfafe372354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23bc09c0a0099eeb65530d1b03ee2f9e9f6f5b24b27b8963f446053baf8363b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24874a3b0c55c044ca039429a62b815f580d05ce82ed8984db10a27874788419"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a45f8a8ed0b740d13c3c5c7e85091d86422bb74775c8a7aed6a84f7b8364a64"
    sha256 cellar: :any_skip_relocation, ventura:       "fd97707ef8aaa457d69ee35cf1ec3c06aae51f2732654826ae4fcefedb6c367a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22d53b841490b247875b8136a9541275fad14bac872c58d778cafa74aef67fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f72a24f56df9eeaa6ba0af2bc330654cddc5a45f233113eb9f5252a01e015b7"
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

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
