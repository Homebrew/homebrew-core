class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "240c0c158d09a45526b3b30abaa26d815a1c838ee66b71b0f071994c6f1790bd"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d381b561cb4aec551b22d2672087dca377384c05855f50bbaa46920d4ea4ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951964dd6b4a6a3f434863e0e377797640775f7863c6107f95a49bb520a8de55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430d35bd22ab7ee44568f204142f390f2992630957498d484098b2dc1cb308d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8900b7e66f5029139f97a1ac9a949044999821467ab3c785cd0870ebd7f4b4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3e7c4602bac1eecbb0708d84543e6f1d4e36620ba498c047c0c2389e0bc614b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b774955a3247e3e5712ee8396857d6eddcb3a2503a2cbd75dce8325a8ec0b050"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
