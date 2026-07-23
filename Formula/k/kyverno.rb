class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "7c93c274b8d79d21413fe7bbb9de4ace9a5f7fb64c969af675f6492c2db95d39"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72e6e9262e9d357fb81113361c0ba5e36748f262d5585a818dd069443d738f41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20084ab926c1c18eaed6e29d3220028b4599129bc4ae45585f5d716f8b1c0c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4084dcaee4d94c2577435a9b396333639bf3fe99f35e955a2f59bd8ccaec95fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5513ddffc37b828f202fffe3e642ae0edf6219c88dd1dd1f808636f7f6d0591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb66fdcfe70c9655a3609f5827b9cc4ab69ce8b3732767bc5b26ca3a4e1606e1"
    sha256 cellar: :any,                 x86_64_linux:  "2e680f7579cf9f73c9e53609c0e2e1e28558dbf48cc9eccb0ae2f6d79f4e4402"
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
