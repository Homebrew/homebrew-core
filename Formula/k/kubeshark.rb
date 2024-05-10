class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.0.tar.gz"
  sha256 "73f637a49dd9da5577f0127065a1baf0eb4888e074179b0492a845aecb3ba7f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "340f75523bf94e1b7ab7f213156cad292cf8550e30304afb1abd20add1660037"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b192e76ae03fd7b143a5335a6a4f6de2fa7cf10dd1ae87680dec7b4646b3e267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4465c2ef274e26ee497faed517892fa921023b0ab951e05dbf896c73bc1b907f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6429441dedb6a80b0f7039717b455a89a1f60677695052666fcad02796cdb3b9"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd5afe5d98f9704f497638ce1e0bce77094051226ec88b7f6354742dafad9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d06083645a9025677713a77164f81b9fb91e2522021e97b0765abbdd8ebe0f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511839ebb2d1be35e07ec8cc997b58c0353fada865e3dc18efef5266b6361321"
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
