class Mesheryctl < Formula
  desc "Command-line utility for meshery, a cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6b",
      revision: "bb80f4a97c8020aae6624c672ddd2a07e84c2733"
  version "0.6.0-rc.6b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

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
  end

  test do
    # We need a 'y' here because mesheryctl needs a meshconfig file to display version
    # of the server along with the cli. Since it doesn't exist yet it shows a prompt if the user
    # wants to create a default config file.
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version <<< y 2>&1")
  end
end
