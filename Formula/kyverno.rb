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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579510136545bed9cee00923bff862b5b32814e58b4fedda3e03284b9cccde5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a59bea9c9b733d5f22cbb16f1446449b9f4d5dcb9cd3d12c4b9bdad768e3376"
    sha256 cellar: :any_skip_relocation, monterey:       "9fff69792c969e68e7dda7a624e7b7743a025b4de3efea8ff3bfe0628c0272f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc78597daba6ff44cf6535a2e662b1cc428150cc579af7fe5a2b2965cc43c2fd"
    sha256 cellar: :any_skip_relocation, catalina:       "5a7d463a31ab7cbdd3f37195cb662ee36c856b1348759b43b14df5e6cc2902e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2eccf9249dcfe0aabca1610f987b41f2a2083b95697382e9c5ce93d21d8368"
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
