class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.81",
      revision: "1f587170b8db9429ecc812c1ac783127c2c3e8e5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36fd36869b40e3ad47a678e53bda880821132392910a009b80b7525581cdf82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36fd36869b40e3ad47a678e53bda880821132392910a009b80b7525581cdf82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f36fd36869b40e3ad47a678e53bda880821132392910a009b80b7525581cdf82"
    sha256 cellar: :any_skip_relocation, ventura:        "23447db0878f18700cedebaf51973b1a7ed347e3215d4509502bee69ac3f3211"
    sha256 cellar: :any_skip_relocation, monterey:       "0a5b8f94e9af0fb0aa285ac1e86c29b006b844439dbb17885fe5e2edfbda11f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "23447db0878f18700cedebaf51973b1a7ed347e3215d4509502bee69ac3f3211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a53539a9bae752744d1ebaec2232c112ef24d77c321c8b0a4a4b805f21f2c33"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
