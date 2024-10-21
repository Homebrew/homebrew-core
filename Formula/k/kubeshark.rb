class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.84.tar.gz"
  sha256 "25394810711d554b26a1e63f525363c8579464f818f1af0630fff6f602a57128"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac4301a61fbee01422dd51ec629f54dc3100853fd009fd19ae961187d8de3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4ff8bae145f4cacbaef262ae462c0ad219a0cf4ac061dcefb3830bc0cd924a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dca34512c48a440709ae11aac44dd64daa32d9e7e5d05395d7d941b2d75b7f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "04781f2a0437618b132ef4467e988047cfaad5a06baa746fde28211665194567"
    sha256 cellar: :any_skip_relocation, ventura:       "3e4a211fae1a6ec03f2143a6ea3b00b785ef0c07e838a51357dbb516bdfc2cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772251a256c2d2ca5ad3537dd6f45028114e1e56a8fbb165da33d34a3201b88c"
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
