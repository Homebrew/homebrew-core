class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "6710c49ce1f4489330e6263a927164e9b9b439bf5046d116c39d045ea6c39812"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f002574aee466087b760af7802b205a0a2c5400d3d3747b762fa7d05003912c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592f9de07647a0a24735412490d76da88afc7218f7d8df5fb9fb68491d83a262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d76fba16c6e217f95e5da4fab0507d63338693d1a1d20a383db5b6055810347"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c6b99258e6fef26246455fc1dd058feb658b5ded87b829f31eb048b493bec20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d82dd4b40cc40ac7e3361351716c457e72c6361c0d62a0b7f3a449390504e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0bed3d818d1e291fc66d5ab5e9eff41ac6d8ed475c024514541db9223ec66b"
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
