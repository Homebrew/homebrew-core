class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v72.3.83.tar.gz"
  sha256 "839d5fdd31e1c129541326b11564bf0d250c40fb0bb5ce7b65a93a6e48e90a60"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f54432e141f4924a6d7d438ecbf5990eda5a18a1cd8ce99be3304423201e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b008f15240df27626e16ff91a41d6e969acec9dba975362d68bd93d58835a8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f3f30f0830e9ab88b4b3d67d6591f3238a4437cbc8167e0c340beea535b526c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad36de67bd7d5eb00276036a2a4f053c8e1a71e71a9a8d6ddad1b158401038b5"
    sha256 cellar: :any_skip_relocation, ventura:       "fe49507c64cf2c215ebf56a4395d360c2e8f182afbd277061ab725e081f853ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e0b6a11ecb99c6526f18c41c080b3ac1370973b6dae0411d71c60cbbc937b7"
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
