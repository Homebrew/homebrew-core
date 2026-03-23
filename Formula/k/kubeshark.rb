class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.1.0.tar.gz"
  sha256 "09260e91b9feee251213bef5f3decb65ad98b71547140abba6f06fe481f22201"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22762e550f43a4a363377fd5230464288bb77121af2419908316288eaa6421b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2970cae573ce407a2809415a985b78ff6de72b9f99ef6e77a6ee90488e9d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7ea6e63a2e9017a793050b74b31220e13020b131a8e600b5b1a32a6d34b21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e197f27e0b2058bb6d648200c36e5c604922e852ce7039261d25d43d767f6570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322941647cc7da376abea027f05c7a2b9ca89fc05bc5adc1eae372839a447eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef61f28b288c37e1d043c84a085ca98fba52974c2b9ff9affd194c338a1ea73"
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
