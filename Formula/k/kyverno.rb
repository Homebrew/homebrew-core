class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "c079576b7e96feebc29d7db24f39d3594bee99fd6c1d009c267d8aa8d813728e"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946b167bf00830c7565a3dfcf38c2970a564a6ea70d1d5dad2537f509dbd9c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7303f9938442b8990e22034090b12f7eee791bef0b3245158f046df6357760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "182194ec39eea879bdca1192ce081344e82986eab061243dd5b1d903752861e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3220ff8080c7868cd998496fa0a857fd2b71a65772015635810c4bc5d37e9f"
    sha256 cellar: :any_skip_relocation, ventura:       "8564e2173faecb48e7c4a99e0a6faed20208073f231891ddb28ff86100f4b52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364535163f47005935ed0ad9957ac6cf0587ebea7f48717a55f42b609989bc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26220636cd74f3504a8533828527d07fd8c5a4cc135e7f67cd76e8a92f4966c"
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
