class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.6.0.tar.gz"
  sha256 "b613c35a7c955b681e8517d9608c5ef28f429f72632020a4241df1428c7444c8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5868c967311e7989ca6b8dc837dbf766936be4c1d3c97e5834ba9c86bcfe474c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3650fd082d8d4ce6d12f50d11ff23eda6e28b4a1401a8c85850688d1135819b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ccc1203f3b3a18e2985c67da13f76ed7addbde1f5e18d03e489105d34262fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f512b8f6ce987083895aff48cb71d1f63a6ccefbe76c4b27845805330a3dec36"
    sha256 cellar: :any,                 x86_64_linux:      "95dc8de170d1112a46be6dfb4ad011ca02c75f1ec2a1367a9cd5b8971602c95f"
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
