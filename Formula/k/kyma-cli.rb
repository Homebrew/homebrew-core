class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.4.0.tar.gz"
  sha256 "2a79a062ea29f30b80ce39148c1b2bc7552b29e449cff5f98d77918043f4131e"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c412856b2e10412c6e24fab0f94570aa5c24ed87b0b43ab051075733ac4297ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db0a3d99c587a11c7329837e44912012c8044f537719fc3c3c0815d3aa47d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b68c1d2343f89f2a598fef054e4e94ba33948bd6b5ab4bf019a7d253cdafa20"
    sha256 cellar: :any_skip_relocation, sonoma:        "185f584382ceebd4deb07daf8a8b357b6c2c7ce23fa08923121dd249db028202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f578102c7cf812352c54b1a67a3744ed38cbaed7c3f84242c79475247f3be121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f8a5c48d952e54a1b66c5e87bf9fa3e2a87a4a05c88466b88ad3f352f88170"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
