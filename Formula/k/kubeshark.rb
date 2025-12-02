class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.10.3.tar.gz"
  sha256 "df50ec7334cec28373a8ebd229de3dec8a7bca67a105fd55c7ccce98dca7a9fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e34ed3c83e169a8d4a6865da0ee087b45a51384f56467223110e7c9d554b30da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb0da8d4524d9bb756411694c43cb6328d0894e1b484da65e790909952ebe71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d19678e1f7576063e1975dc53c5e81056087651c1ce765b123e595215ec8c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9defa2402504b99343a8424e79b281010e7ec987c7419759a62b957a15a17646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2839d2d895555e3ef0d456c5cff61641c658b37a4197727976e93f616cf8851f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c641c16f86d79a6d3479c7c5e18ed1e08d8aef56f199e4966a24cfaccdff5b9"
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
