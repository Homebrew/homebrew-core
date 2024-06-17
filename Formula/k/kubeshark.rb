class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.68.tar.gz"
  sha256 "05ff6bbf11c1ac0ab6467d987b6050d850edd1bba6325766873de76e7cbebdc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c99a7d804b0423c93968d40e8b2e38c3a868a5091db966d5054e3531cdeef696"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b0244a22b58b27a80a4d8a535379ac879afa57f2f7bbe317fdc50b9bf7ee67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dffedf199d4bb6e8990a6894266e5fb363b8594db4b12cb2ebb8a9b5515f988"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6d4398227a96fedcd6294bb04ae6e7e79bd34171c5ce8217020092f65211c81"
    sha256 cellar: :any_skip_relocation, ventura:        "da7c66de01e4c7aed204e40f6e4b3c2592d5feee5f8ac8e1ebcc3ffa696eae70"
    sha256 cellar: :any_skip_relocation, monterey:       "9231e62f3ea388a40c196e6e2d69cfe1132bfce7f41543b3e63669e34b03f6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecd2cfaf38219a1b26c36ee00f3adbb7a1447085e989724cb1936707fbfedde"
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
