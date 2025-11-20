class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "87a27832aa43507f12dd1fa3fdc39e7a44e64341ff9faaa081a60a6b150ad852"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d037f8efade5c4a7b1e75b213730d2cb9330412ad4250692f579200d6fb7867e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e91b66016ad37368ec6b8a8002f0941f9afff50a819f0dedf2f7869e66c94c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec8c8280812f7ceb3c5f19a1eedab28d7b9925fe025c21a379d9af51065c051"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c39bacc470739a9745c801886cb397ac9770e39fc7a4f4456dfe1eeda2ad4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "054448cc5d0fe0f73412478ae97b10221ec5fce52cfb163e3d1cc29eb27281ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ff5d368ceabe42d4c16c31d8dbf3252ec9436c67389b3fe611f6ad23abdd1f"
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
