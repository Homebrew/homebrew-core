class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "19f3499ba7d0ec3db3f030e338755177cceb7d8a4b6dcb0b6c2c49d2e7fcaf0a"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "701994972aea6c83f9a2dd98d5d55f12f278d4968eb78d23d44721628763c10a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033f345f0c28b7896c4f117ad95078fb9930f8a629ac1e0de7c3b6510a597ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46b98e864ef9c5a512d06edde86a141c65b3f801c11f92757b21e343ea58328"
    sha256 cellar: :any_skip_relocation, sonoma:        "229349e906880638d7067c163a64e4baca0ad5bcf2cd9e4c65c5b8ab06ddd045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741802c57536efe8b59ee9430400ad76984d51fa25a49a7526b303f22665a76f"
    sha256 cellar: :any,                 x86_64_linux:  "85343b032de8064211b1b3242d6f991fec73f1b310343cbe359a2e7924f8c134"
  end

  depends_on "go" => :build

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
