class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.4.0.tar.gz"
  sha256 "78fffe1f32762d54092bcafc6edf721019fffb224cf7bebbe6029224b9067b8a"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6499bf4ff3689d8b3e4c35349256cb30eabbb44c9d5f3a125c02f3724abd2f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0a6a8a41bc4774a5dccf71aa8b28ea5fb1e07c4883b76f9cdc3d576206f589"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0257537b62f69f7175b60ab8e3407b3b0d1aaae528521881c4276fb8b0178fa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3559c444a025445f2935fb4cf4efec0828438f8c33f697e87f61eb5dccdaac02"
    sha256 cellar: :any_skip_relocation, ventura:       "a427c07b68feb2010e90674b802cbc68a751b934606aae5f4aea462b449435cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e516dd15908fd9f2bf34d443b48e5c491b1367cba61a155f254d88b449c01bb"
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

    generate_completions_from_executable(bin/"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
