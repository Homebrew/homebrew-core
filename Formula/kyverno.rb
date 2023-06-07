class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.10.0",
      revision: "da6f5c18132f773af15d0e09cbf2e16a36725232"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eef4b6a63523770b00a10380073152ff468684f5e6ca69b12dd21b9a36085e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1fac7fbbea2adfe35730bad7c6b0b30f0cbd3d8905370deb6481d625b58f804"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52ef2caf82b4f194833654b8245c7b1592907dd87a3b1740273ed7175be4c968"
    sha256 cellar: :any_skip_relocation, ventura:        "6a35f17731a40c5cc686368e08f37f385028345727a3d9f075d0d33571bd75c3"
    sha256 cellar: :any_skip_relocation, monterey:       "1a236c4536290ee95be091547e7963427ab30d73c1d448e38345ff63931cc3b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0504142ce1d768dea31302d0a8fe89412161ab24b472a64d1156075074041de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dadb34b393d8602002cba20982da3bf32c9ea8e3d1891394bc421b7bdf1c312"
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
