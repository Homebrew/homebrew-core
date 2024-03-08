class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.30",
      revision: "70796fb890d6daae09bf0e65603af1d3e926bd98"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7da2514226bfd07c9fd735bbf33622ab2bc1db01c8170fb75bd130fda677962b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da2514226bfd07c9fd735bbf33622ab2bc1db01c8170fb75bd130fda677962b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da2514226bfd07c9fd735bbf33622ab2bc1db01c8170fb75bd130fda677962b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab7ee68c0b34da7aa91b07ea1e0fb692ff386de84ad364b1e147b1fdf4e28280"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7ee68c0b34da7aa91b07ea1e0fb692ff386de84ad364b1e147b1fdf4e28280"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7ee68c0b34da7aa91b07ea1e0fb692ff386de84ad364b1e147b1fdf4e28280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a060e3da73adc3c033c8bb9f8c7ce5421410e03f1536fba300f9872c1a57033a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
