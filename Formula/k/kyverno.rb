class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "96f74dbd86f27c2e125937c8ec8a07948cf2a42edd88a4c5126943208a04f8c3"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01dfa54f875473fec2ab73e0aea23d844336205957a805da680acda6c4230066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21126ea4fb6f0613a268869a01faeff23a3a40f816365e1631744b43a3a6fe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbd09d61279e6a255a6e959b1cf2eef66c2487ac4eee9fc37c3d9860175bc6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "569df05e6c8cdf347fd943fefb734bfbd2a80906a67199b9a4ec4c09bdab5bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "ae7f15a17f324b43d09b24a9434b7d1e7f505a13d81e5244167558b4f03cc99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df8e3d6f213699124001b5243e9f9c9b29832cd81f05667f95d4b55ed8677ab"
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
