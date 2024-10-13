class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.83.tar.gz"
  sha256 "7e2765654d86f617f17a649cdeb715cf3faae78416151e9a0bec6f34cbc49e3e"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31ee146b9c9f4566ede6b456f5f4d7ef6a33acca6c6fa2181427295f316b286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e287e4ea66b5684b915764ab4d31fa86c02c7179b84ff8f33e9878c4bda0a6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4431a9e472326a93d54b12143cafcf7634fe118053504eeeca8b852791c36e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17c34d332195c20c2f9b8095542f4fa928e4ea9d1d7a53585e8ce6e650066a3"
    sha256 cellar: :any_skip_relocation, ventura:       "a940155cc933deb01370d3f970914a59d3371e491e7d89e52eb62d8b94ca097d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2e79a2837682d9c40fd60cb59c7ea286578592a5e0e8e49b4d8d48395357ec9"
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
