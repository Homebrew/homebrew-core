class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.23",
      revision: "9e1c8f481077d55f0b38c6bfc9c1a32420e27587"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "734219559b58d38565dd2660090838a79b99529e2a810fce742e73505092c5da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "734219559b58d38565dd2660090838a79b99529e2a810fce742e73505092c5da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "734219559b58d38565dd2660090838a79b99529e2a810fce742e73505092c5da"
    sha256 cellar: :any_skip_relocation, sonoma:         "52e8b0bd935e0bfe10feb9a6078687c090626bf0cf5a92f7256d8769a703f653"
    sha256 cellar: :any_skip_relocation, ventura:        "52e8b0bd935e0bfe10feb9a6078687c090626bf0cf5a92f7256d8769a703f653"
    sha256 cellar: :any_skip_relocation, monterey:       "52e8b0bd935e0bfe10feb9a6078687c090626bf0cf5a92f7256d8769a703f653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729c674f0aed105e8a7143100f21495462078b9a195741fa27166412a585c142"
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
