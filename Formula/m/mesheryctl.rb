class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.151",
      revision: "86c02241e56fd7a28d4e715ceebbbd57b7f1b43f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa0c9afa5302b16ca9b3af0dc2e61d0a1805862a64cb7f1b814638876bb25aad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa0c9afa5302b16ca9b3af0dc2e61d0a1805862a64cb7f1b814638876bb25aad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0c9afa5302b16ca9b3af0dc2e61d0a1805862a64cb7f1b814638876bb25aad"
    sha256 cellar: :any_skip_relocation, sonoma:         "c861907c581af5f8443b643ca8a0b4550ae341d990119cdd669f8a990def1bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "c861907c581af5f8443b643ca8a0b4550ae341d990119cdd669f8a990def1bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "c861907c581af5f8443b643ca8a0b4550ae341d990119cdd669f8a990def1bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222a697d8bb177bf2b85c6921d25dddba0c6f93a8369134465be69269737353a"
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
