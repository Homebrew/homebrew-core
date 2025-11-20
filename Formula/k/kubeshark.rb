class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.9.0.tar.gz"
  sha256 "2318a65e1bfbdbd26903e76c97ca5dc6a93ccbd97f4bd1e87a25e2900fe1e750"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e07f0d37b2e286f4e224887e1e7a7b3303523a67f7680f8a656309dff6d510c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8912fc8cdfbac8dd0ece8e7a0d4ecf6b4aa76860e1a563ce5db1523b0effadb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf82e4b4164988e286baa4b253ceb3ec0d47c0f3e2414daf30524cfb21cbe314"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f8b2901b274884d29763e853dd3f9a1838d206567551852bb2d2955cc532cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1221afa50134b597909e4fff54ce7205c692e0cbd6b13d3a9917717bfc93a6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd47ee599faaba45ba0ab2aa20504a98053fa6f06e82ed1d31d97ba4023d8b3d"
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
