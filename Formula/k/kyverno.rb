class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "0c9b9d768448408670d41f98e4c6947d677ec1b793782d841e1f325707eee36f"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a921121982936c69ee1c2a38202fdbc6f5306adfb4e1a23f0fe3eb3cd829efce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395efc3e4a183dae81489e5dc92b00fa89e9c48db33ac4c87f3ec6c831777f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45058d1ce4487017d2239ee306e34f47788254aeaa3bae4c349d8e2489763329"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f8a869caa44cf4729738df5f5b4be34afa2a5fd0a650d38edd1d98406cd3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e657487172111cc8b6188cdceb0925072956f165f33e96cfa2a0d9042e17db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3231552297a653a7dcb1d6a1e8f17f5ac9cc1d640e81e12d9f1e4c798eef24ac"
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
