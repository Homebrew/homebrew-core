class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.65",
      revision: "8eb93ce119453607ecfb210d5c21617117020432"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be70795f56556193bc5dac52655fbd81b04e8d69497c8481190552674ed90dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be70795f56556193bc5dac52655fbd81b04e8d69497c8481190552674ed90dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be70795f56556193bc5dac52655fbd81b04e8d69497c8481190552674ed90dfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ed03b0418b1e7ee035d671476cc289fa36764e82089d73869a1d17d4792ce94"
    sha256 cellar: :any_skip_relocation, ventura:        "9ed03b0418b1e7ee035d671476cc289fa36764e82089d73869a1d17d4792ce94"
    sha256 cellar: :any_skip_relocation, monterey:       "9ed03b0418b1e7ee035d671476cc289fa36764e82089d73869a1d17d4792ce94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f4849638d70735825004d7a09bce129afef17545bf1f70834829fb8d7673af"
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
