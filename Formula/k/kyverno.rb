class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "f016955f08e3113575380b9155d9c93b8a930567b4439be6702e8ab49734f148"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74a624aa1e37e0998a6bc94eef626014181777a11b22b9fbd323f5523ed19662"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "feaabb65b4ca29408962e7c0c4bcb6339322f15f0d3de849dc599e57532b7d08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d33d01cb52a7f536e35048585d9d21e65cb421643cea6e4b1ebd28992ac0458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2017295e4264e8ccaa3819fe3ceb6e441b779bd96d0c3f03d96609e8cfc27c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ca57c1c3916f8e8cc921d041ad0084dd135c70e0019d865fc08e5a895f986a9"
    sha256 cellar: :any,                 x86_64_linux:      "602cb8117c6ee545847395231764633d0f3893f84d77b548bd93aae47c367783"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
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
