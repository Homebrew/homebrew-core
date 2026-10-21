class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.5.0.tar.gz"
  sha256 "da2c0199606365050dbeb8750b7c3d27bc3604b588e089cb9608527637825043"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7038ab128e33c3685045b0e581b1061713a86573c4ba1aca81a9f0d97abe90cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25c2864e8fc2939a9192c2d48cd7b56a6ff220e5aa7d33011f58620c3a67fd22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ba1a55d749007cc140ed74382e46aee89ec18ce81b9ac9cdfa3de013b58aef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae52dbe8b67873f2921e28d5206b70a53562166e8dcf07a955d8a7ddaafee373"
    sha256 cellar: :any,                 x86_64_linux:      "9e7bed574e6b8149253a1b48a6be31ffdd1f0f8c5a2e222000e984fd253ac206"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
