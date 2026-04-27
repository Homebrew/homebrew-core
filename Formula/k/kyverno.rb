class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "4ec5db630055fb34e14e5446d7b23592f9e918a4de05b5c05dd3be2d750f03a7"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e146b81ccb4c15c210877366e8ea667ba4447effbaca10d65c872f6ab6af2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c0309981ecb7384086c57a6888461d0c877c8ac2c23bc928f57340ed676877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba12c2c59e5a1baa8edfa912e9ba59814f518f6493899d9e2c3704ce2ca0166"
    sha256 cellar: :any_skip_relocation, sonoma:        "db38257995541b7ebaf7e1c8aae9b3619f078937ed92dc977d4b3fbe08262a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f359ed88f539c8a03a342d9ad61556c6727523d6cf5677e835abdb8d040dbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d95d7cffc685ab412064ce4ec5f8c9437d1250689c710b337a17dac64633d5f"
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
