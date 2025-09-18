class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c803320ecb68579d99acc4fc2ceb2142399dd4d9db7c2d73bb608b18acf23b71"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1999c97f94386c86532d914fe86fd84fa0d156d895594c6aba60716a816c58d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f6b9b78ebc3eaffe033d6364582be712250850675036c46615e32f66d7e3f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8898322f3ac46f82747e04eeee069db05d5522f3f39e3835ddebded94240a02e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d95a760d05fce8f7cc402348de93c13b7e10596f0f05da093a5477aea571afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8949120f17bbef8d4e7c67cc324bc9c66944a0486c40b62a79f9eae5f77903"
    sha256 cellar: :any_skip_relocation, ventura:       "d065c495dd3d82ad3e61f9197b0237787cdac5ebf6190d9e7b8076e12f782249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a813f9745c0dbca830d4048abb24fdf2e736143c21f597aceb334126959c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ae8a6c6caef8c5e56e63368c8eab8d5b891a7894c0b4ded5a711a2890e11b8"
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
