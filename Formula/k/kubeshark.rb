class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.75.tar.gz"
  sha256 "d70171babfc81731d87c34d1e0fe9db649942a0aaeb8c572ae12a1684d9b2356"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85a57e5559a77f060a664a34b4efd607bda6f5f611ade83dff08a3fdf5971378"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3801c2358f88b0ec14df8943b61ec09f0dd949af90c320cf98bd115658964a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b42dce078caf6817db03f80bc1b503724936739feef62b7936279df0f4581f13"
    sha256 cellar: :any_skip_relocation, sonoma:         "470f2962b5160e83a6aa1fc6ee5f5b5d0c7c459302497f68d5feb3af5683df91"
    sha256 cellar: :any_skip_relocation, ventura:        "8c6503176230ec16bd240fcd4e3a8341a4380380d845ff3962fcb4237b7780ea"
    sha256 cellar: :any_skip_relocation, monterey:       "80c7ec744d562c31ae7030d1b6bc57d8595953be9c2bc07ec71b193471b2383f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9375b608e3387103e6f4db81e051dae33943c050601a48817d56a5150302345"
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
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
