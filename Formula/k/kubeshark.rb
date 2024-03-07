class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.1.63.tar.gz"
  sha256 "2b2c66095430f7038fa665472a34e85165ad041396289c98001d10835fd98c63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "772e0a413748a0f28b513dd26c453c22a714a9199f1f9ebd59d366a3819e16f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05a9f04723ceb8c5d4adbcb6559beab3effbc6780b818ed6c3f2344fc4ee1ffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c545e6cdf1997afe932c79b0a74f4dd350b22f8ea5a0140858479088e9cced"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6c396e74709c6d35cb57f547bacba3fff5a4d0040d7cb51d28f2ae1a7e1efb2"
    sha256 cellar: :any_skip_relocation, ventura:        "b35fab7ccb9efe12a47af22b55b52a1b602274920d38c00b3766d8c461ee3474"
    sha256 cellar: :any_skip_relocation, monterey:       "d14c6b96a2691f4e0906cc0ab98be67d25d1b191825f213c6c2f01838c314584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c8582acd60b75bec61ff8a416f455549f73be229045019be50145d16739cd8"
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
