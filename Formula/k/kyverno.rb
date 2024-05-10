class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "6c3ddf15aaa64fefedeb3a26ff6bcf4ce74c3d8e95acde2815971ed388f5d7b5"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bde3b54b24b2fc6c5ef8e9c345af6324694d026cfae501140c134dfa014e346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f09034d5c84e4af75186e16dbec0956edca7bf53129d6e16a4cc478d2ca10138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d075e60a5c843cdabd2bdeb52b4b48ada845fd2a7645e0cd09a173d9a18caea"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd8f8cd7238d7ee294a8b80e523c746aab54cb7761549fd0431551da75c7f2af"
    sha256 cellar: :any_skip_relocation, ventura:        "fa179f9df2d3440ba51c50561ee5995920602bb0c22231be4970a0d5eeb08ef5"
    sha256 cellar: :any_skip_relocation, monterey:       "5afdd71cc53dea05736e62f5755aee1356a24f7079942e2ae5c121278c861232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c515615416d73fd90c85d64c9121fec33375f89efa8be135d964d8e717f7c0cc"
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
