class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.2.0.tar.gz"
  sha256 "86ecd9f872f9aa579fa02cc3efcff7fcb6fb3335b91d588bb15104d3ff0ef6bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9510ea11f051f5ae1effec8eda09dc26eb41fe502a05d96d9c4c5cbeef93ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "433de7e2dd1ad7dbc57dde6011a10fde40269b37591885260dd010d89c47fbf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19313e59290c135563d82d7acab12dfd7cd6e5711c89c797b9d52f959944a0cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "555e035644cd8dd9c88414643320450a2df27edfd57a8deeeeb9b739a31a4021"
    sha256 cellar: :any_skip_relocation, ventura:        "5df3fa2bf457b7a66cfe39913c8e2de150f67815da150fe79f83ea9441309144"
    sha256 cellar: :any_skip_relocation, monterey:       "c9efe11d29ae5f822b8df22f4cb26bc8ca35e4aa8af8a052f4c00df014943358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7627c03c3baed0ba6397032738816d28e58b206b3d5cf68f48e5ae3698967003"
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
