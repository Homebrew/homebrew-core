class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.12.0.tar.gz"
  sha256 "7afffa42fa13164e6048de97ca522d4751c6f337048aa7fb423f7840d46bba2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e03a4dfeaed44c08d9b1d2402497ec79cf0b3cc45c853f4bba248d2be8d2b821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27781e4d38ec45292834af4a138f907852800f841f20860693863f6b78ad2184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f0f27fbc553f559ab61213befd11fd9df71972f7c9210ee99932695643a8f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfa92b6355b103d1048802216bf7e40ac2c488943d5267a7950b73557b33b5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2029dc15222bd233f2e3a08aa84fe2f0eef152b454a5df37fb9ae7e881ae4fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0a5ea2be05890a741aac761f0d6d74404852fdebb06f14e94f3a1b3bc5ac1d"
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
