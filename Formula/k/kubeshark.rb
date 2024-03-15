class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.1.75.tar.gz"
  sha256 "cb2b0de8f53e9f52635350b20e6a946ebd00249febb81a4715a11ea571981975"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1588f394f678e779f187cf5390e1a3812ec9998b60c347a168ac6b1441a69229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67089d86baab48e650d3fcba13d1e6a992e953bfffc837c9be3b4347658d82e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da443a2d00cd6a48f8c0a57390e467a7b230107d3b1cce886c5bde22585eb62"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0c3cb18ea2ea9ced02e38207c362873218e7d1b70b411a6ef48bc3dc0edf6b2"
    sha256 cellar: :any_skip_relocation, ventura:        "cb857df7fca6a02a34b74bf2291d1e800f245b7497bfa1dd5ace2d35b050f597"
    sha256 cellar: :any_skip_relocation, monterey:       "a3df9bcdbaa44bd62e5302f50ef61e55410ea25e393562de681fc45c735a37a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e08b92b5c33f51847f8a74cd5f34f43a15c98af4bea712e0696670a04b4674"
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
