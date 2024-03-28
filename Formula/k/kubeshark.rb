class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.2.1.tar.gz"
  sha256 "7beee194772df13077e87ed15b06fadab0dbdcc2658fcf8775930fee2842e1d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c06677e9211074816e20303574ca7f3dad5c75ffd757fe0b74c591eb1c313115"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079ba15dab9d07f7e1287ed62a577b7d3f06645772e85615e341d1eee172d517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9655cbf15fa7e5cbe48143a8e40a69d11341c4708d1c6d85ba4c484e828bb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "779ab5daa36fc75aaa639979fe8440581e6b5dc6226360278e583da4592f05e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8698a7de44a23cb9267ba01343a4880f7645e4822fbbaec63d35e8f5f5a46ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "160e015fb0d381efa899d0f1465c152f829b941ce6150d16f9d37a41f25e5c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c2ddd85aa3a19f3029610f8e24ec023a9869d1e610f8950e67f025e1e1f836"
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
