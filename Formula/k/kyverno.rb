class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "27e1df853a24afc5cad5f18e447158f15fbdb37490120e5304ed6d111c0f2efc"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0606fd94ac5946afedac7e0228fa348b07ad01dcbc197f5018232e4faa0968b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ce1560a67ce894e69a20e94138cedbeb18b3914d4f6313eacf28ee38f1a60b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1512af21bab0bb2b0660f6985ff8bfe2c1420dae1d45afbbfe7c414a2459486"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b6b8a9f7b9c9aa2f4aec71c6ba53ddc600dfa1db2e47ef8c65a19ad0eb36f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "9e785dd820e3caed587f3cf39ee4fb2d40c72a157c8b65d4a8e2909c23f07858"
    sha256 cellar: :any_skip_relocation, monterey:       "e13c5cb1a6d6534af38f9839f12404ac872b6058cce1276f39b55588bcbead88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f8f6c517ab4aa9b3b1c73f874a7bc2d6474b5a75cddd960ebb91eb9b6ec08f"
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
