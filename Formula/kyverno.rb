class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.3",
      revision: "dab311d6b3d75ce0b20e6166dabc479b08d5c98e"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee86c52f20e7c59a23bf7d0bae03fa94b106395b3117f79d6c40437fa2effaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839c0fcf48bc7ac12fdf82f9edb8f6d3c7a56bc7a38287a3ac63df3723ec887f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30f53f2652658a5aa0d3b6e4f033071cf9147ccf7dc830385e53fa4d0974f2d9"
    sha256 cellar: :any_skip_relocation, ventura:        "d63484e17f54505ba0d0c282bd18aa54b46dc70097cdc0a19136e60fbd7ba3fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1536268ebddd066e42bf43aafef016ef53979427aaab833737db8bec6a85578c"
    sha256 cellar: :any_skip_relocation, big_sur:        "459e9feee35e007ca9c6179e124f02171263c9563c3e4ec964d57f9dc5ce03e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6b3f1003e682dc9fb0c2f280a4e483d20a53630f0ad1b7bdd45f4dd641f3d4"
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
