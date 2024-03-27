class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.2.0.tar.gz"
  sha256 "86ecd9f872f9aa579fa02cc3efcff7fcb6fb3335b91d588bb15104d3ff0ef6bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ba3dfa5a038c965435cb169a5970ea59cdbc1d3be97ca6924480fa1c01efd6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb035823f711cb8cd97ea94dd0ecf37622db02cf4209574776cba272de28568c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c721598a832326633cbb5d5982ff1d5a715967df6baa1a9477e30ddc0546e339"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a6425c907eb3d995b9577f017533808a2145b91b61d5e3910bd1410ca862416"
    sha256 cellar: :any_skip_relocation, ventura:        "1feffa0d3ff6d0c483b42f85be101d696bfdff9658c3f6173c9e4ae705d01c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c475f3f65d8444acad8a8ada2592fe2de2b8811ae94a3a2605010e527fc0060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5975b14bd2d3cee6c7d6efd67965b5fbe11e42a2edd1e5b630b6a3b1cb5bcb43"
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
