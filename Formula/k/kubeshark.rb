class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.95.tar.gz"
  sha256 "9d44f9a2a0dd93e09a1f3db7d126fab62a8cbfc8e9a89248d79533df6ecb5624"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1eb9fa3cc7aeb189cd0c4a493e1829511dc07ce5e441b3ce8229981ecde3f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ac8f3364cab6aebcdbc321b5aaf0d8fa01438f2bc1e431740b5af4825bc457"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10aa8970402df34939c606293ff24cea42811a83f5894bb13752b3eb67d7735b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f3982d7455b41075748e3f11f20681696bf49055b29d882cb8fbe3774f9cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "867a16da6bc6a12dc53cdff624b5806aac29169ac8d0890f2470c7707f88fa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd091e563dea8ac1181df2b9937d2c0058c214ad38c151ddd6838797234e077"
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
