class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "03285a7ed3f24ee99d62b5e00829441627219f9f81702e4c8adef741c1d83707"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c50af350beda536ee8cce8e75709c1307f87da8dd664d3a94d397611f4597d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5420fc6363ee3cd17f5901fcdc97907f8488d0afa81225f7a77bf6f399f3ad38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1383b5d97f3231db49e9dfcac38c5c105c228e7f96253d84e575fde8ec618cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aabbd69fba029b8b0f50909e76a67c6e6137863c4dd76f8325fdac502f242672"
    sha256 cellar: :any,                 x86_64_linux:      "ea00c89ff3a089f4091caa63f55695bbdf2ad337eb430f3f3a1fe676aa7dc5ef"
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
