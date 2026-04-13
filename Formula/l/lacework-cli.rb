class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.12.1",
      revision: "4f8e2473096b84b09c6a2765ad46e18f4d7e08f4"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3363e2109902247247d366eccc00d0ee21677bc7a4d2be4e6d000cb12b188b95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3363e2109902247247d366eccc00d0ee21677bc7a4d2be4e6d000cb12b188b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3363e2109902247247d366eccc00d0ee21677bc7a4d2be4e6d000cb12b188b95"
    sha256 cellar: :any_skip_relocation, sonoma:        "13020a440ee7c26121b2361039d37542b2d0f20786044fd8075f9398bba6b49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "243b382228738f9757349a51d737c21b08bf5dcd462cade222c095d1014ffcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9683dbabcdf8792f57a51cb238ae1cf67df13f01d483ea0a26533cc62a0b86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
