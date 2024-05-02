class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.2.39.tar.gz"
  sha256 "c1ee1ae0b46717cc76f014a02ef0477b4e1ee0ea114ebe7ea9d3a877355f2db5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "579bfd46c81081269da277adf3148123f723cca74fb7363067f512736228215c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55ff01e3e7329603ce4864c3b0eb552a2468b57d0beb889d6265666672b395a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff61af69744bd5a7b5432947a7fde1d34d77c7becf694468ed1ff18abe65b9fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d23c168aac0f42680e642f6676ed89718fb2ff03d066202e93cc706bf79403ad"
    sha256 cellar: :any_skip_relocation, ventura:        "60197024290e3a7633603ad74d0cd0e3c4c7964b8716b64950de9a4abc73d080"
    sha256 cellar: :any_skip_relocation, monterey:       "9098fd5f717ee7c9f6138990df86e135e8cd5f9661f91236f4353501cdac328a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037bdedbefb03fb8f8f21ae95c52a154312b50cc359b796737e9e34d2c2ea748"
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
