class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "9c09a8cf176357852aaf9b81df0c609099ba72d6591b9e2148984a5b8cfe1dda"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67d311a6f158a85e5a6740172b3e7aaabda2934806ab1a2478b3f2ecae5c4d25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f2145f577c4131e72c57f0474e9d100cd4bf384f215fd47f0e6d33723c7f35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bf9bfc8e6cbbf2e421193e76aebcbe44e734e2479cfd780a6fe6595cf2be987"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22dc9b4c2522c00ed451539161194c96ccd1856837669afad01dc18a17bed29b"
    sha256 cellar: :any,                 x86_64_linux:      "20a48e61baf679f328a8ececac1e98369d7675c214ab855905fc56b604f1a846"
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
