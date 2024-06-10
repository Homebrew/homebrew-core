class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.62.tar.gz"
  sha256 "28d8bda60f7cf0c86e5efef76a4c06c4b8cb5a73ec6f76d5b06b74911ed557d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "045af286a7f523a0cc32601ce3005d7d328953235085e2184ba676e4f8d8b941"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a5d044726006f0e63f084a4992f226add68b5cdae58da44a891a0996e4836f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b6b772a5c6fa65ecf6b382b17053702a2c35feb3b96786e6b0669d79656283e"
    sha256 cellar: :any_skip_relocation, sonoma:         "06a0b2c0a12018ba764069ae3c9854be8b4734adedd833231932e9d001875c67"
    sha256 cellar: :any_skip_relocation, ventura:        "1bf043aaffec80bc2711b835ebff37a4e4a2fd18e590c43aae04b283e2d2651b"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4c9d7f45bdd6bb85809688c52a3b47ec0ed52dc0e69ef03516d420952d4d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c34dab6018f8cd9f6983b3143906c3a8c2a1b2c5206008672cc94075db6c9f8"
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
