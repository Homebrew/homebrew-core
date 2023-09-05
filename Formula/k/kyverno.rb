class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.10.3",
      revision: "8137b4b8afd7ab1464a42e717dc83f1cc471a4a1"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f8b0c3fe16cf900f45ed87d68379157e910bf76b2de39fe73c1fd3463820775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556864677a30ae20624cd21f6f5cdb63a5995f0233e3e0164f2ad56f3dc3c5b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afce11f860d53d1c0cbfe81f442f6471f1c2e343917491d96ad77ddb0c4122b5"
    sha256 cellar: :any_skip_relocation, ventura:        "95f057efe027d223c97bcbf41627f746e8610e1d40e329223a0a17d3ca273ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "b2506132df225d6cd2d356d10aebf26264d139efdc4e9c78dda5e1c51a9e04a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e317092c54c427d8649e0bb8f2d800520961f1362f85c8ea0804ac1f51f7d4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96c6b22b6cf683e3058d676645d6fed56113557d697f943736b970496313b5a"
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
