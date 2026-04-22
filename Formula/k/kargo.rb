class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "35e87b5fcd77df75b30f042b5bf02d4bf5817bba01bbe5980fce6e9e4f2b8687"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4adb382388637733ee41f408968dec79a03c73fa2833a565d52da9ff850f8363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1881ff4e0949228b9f73f41a06aa86de4991b86c00fb493ce5924451882f87e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b0d1494ffb686f08e4d20aabd55fbd78db9e0fd79d7c3ace85c269ef6f7db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e3a64cf3021f1c52a8469b59c90fe744959c4275f8d990f26650bb563826e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2953569b63d30b761f1f6ba98b58812c0cc4c14f397290ba26bddf73b4fb8881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e2e35169ecad68fc81849dfa495ec7bbae77a741f6b5a6e8a155d1ba3582751"
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

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
