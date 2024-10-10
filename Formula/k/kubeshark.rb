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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573ce9714e39194501b5a9aebe9d9f2caedc3e47c5e528d3a09a88b08b04f6b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b1575225d97c9c39c18f8e4372ac484b6aab52d2ad449875cfb3c10f26502b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779809d7641cc384b73b6217591e0aef364520b2312f85a8a0a98d1e5bcd9dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9317c082ef7435e31296d98f95695638e7d3d74d6e646e995cad52b1b6b7475c"
    sha256 cellar: :any_skip_relocation, ventura:       "d735eeed5b9e38dc6b58d08b659a7731f008119007a90e6f81260efe2ee2b470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f1d2b00f2ef40104ee17126c84d1ee8fba4c5a7617789e9cb29754cb65864a1"
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
