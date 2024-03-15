class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.1.75.tar.gz"
  sha256 "cb2b0de8f53e9f52635350b20e6a946ebd00249febb81a4715a11ea571981975"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ba3c50c811d38294d68246dd4f224d53efd8f1f2015c537e6cfe9020fd5e6d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d37a43bdf2dd890030ef6eca507adf9196112267ab4e874f244617ea96a107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4f27fa8411f79eb20a23a2fda304d228a766dee6a70170c4d76cf2cc5ff305"
    sha256 cellar: :any_skip_relocation, sonoma:         "25cc628e89e08af1ed253d503ec1707c4aafa69985d75b052fcf9ceb26e5e5ec"
    sha256 cellar: :any_skip_relocation, ventura:        "cfec60390efcc40994e8c921f38bec7c2e7cd22414ca259b2f0ac6a47800fb0a"
    sha256 cellar: :any_skip_relocation, monterey:       "f1926c336bfde14e262b230065514a8a1a5183eb6cf733984d35cb4fd5bee89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb53c12945e627ab72a02948bf75a1a1896b9de759f0bbdf20a52dc37dd80107"
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
