class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.8.1.tar.gz"
  sha256 "a621d948a0f28560b494202bd884b39ee0d6de024edfd5ac9a70a0d067ca1310"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a69a07f2194219df0b24c62681c4a2777ec3810cce06d8058d3532d6c2762219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65e38045ff18f7fc6fc83df77cc9da945ec7e99033d43f91994f0768c2c2e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6672c1ce14d11d27b1c36df869bf88e49873aae7110edd01ecf6463278753bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d430d8760d96823fd593c020d1896ac96bd1aedb55c377c2e9323a189e9637e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6954043a3ea85d11def574d454eda727e637c4f0de7a1e2c174c9094bccefc9a"
    sha256 cellar: :any_skip_relocation, ventura:       "53507760c14e7f713d99500d962e1f86542416736a50a9af67c2f44af5474915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c36b884d837b3b252c4d7d3e966fac7174b90ec7ef9853fcdcbfc60ea1474d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81568116c1e2806963e896671d7239833257a7e37ee5ec885b1a570a0e573e0b"
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
