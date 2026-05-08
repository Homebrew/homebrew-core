class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.2.5.tar.gz"
  sha256 "ef43ba3d47652fd640d78b232619b631c50d053af86e251f0a797639178b3b5a"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b288eaa214f8b4aae72f29d25c7619200698832fb8d4db483c1497af33e219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebab2c17c1dd87898774257ad3baea5760e4c7bea818f7292efcba4a1f4082f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ad7e3e83571ee7bf03727c69a3210caa2f8eacd384b0c871b29a7b27908c199"
    sha256 cellar: :any_skip_relocation, sonoma:        "da7e8537242643d6881be8bf195ccd846292d0fc48a2e835c0b4a38d9b0b1ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d78398fcedd3392a0f729fce293fcfcff58f0130afe9f60358f8ca7a3f0e90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e3f95c0b842415f083d41b7e9b61047927ae7a5c4c1a65fdea91eeed781336"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
