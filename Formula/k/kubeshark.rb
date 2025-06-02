class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.7.0.tar.gz"
  sha256 "95352f8e7ac71c570b1dc23e2504d6eed70952af6c4d352fbc3dc276c613f7ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11c4aff6f7604d4b12dd72e875a950e422d2eeddc920048e7e18fa89f92da13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742f2d7552d895d2453b9e677fccceeb31cd0759fa9538b6b4f77da5e0793ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eca067494bcae2976ba547e30f339a0b86021dc6b0d83e7e73b962ba859edca"
    sha256 cellar: :any_skip_relocation, sonoma:        "879f5828040e1eaf58815b6ba001598a4d43e23057123be77b6052646783bf85"
    sha256 cellar: :any_skip_relocation, ventura:       "dc05e98a496777e3183afbfa8e9000db2360083bc59adf418b6a93fd75a5b09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85015784abc15bb2f5506d007018c86cb4ff72b5bcb15d78cd6c6adde04957e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27bbc7ba14bc4baf3bc15e2b2c7244b8eb0356af83b16f5f79d2edc92850710"
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
