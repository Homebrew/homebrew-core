class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.23.2",
      revision: "7143419d1cd920743ea373998559937f69cc3451"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "584ce84e5cb6175acc707d565399805926bf10b7f60379642acf56ac771be93d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "584ce84e5cb6175acc707d565399805926bf10b7f60379642acf56ac771be93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "584ce84e5cb6175acc707d565399805926bf10b7f60379642acf56ac771be93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e55e7467969e6eb8db708a51aa193997ec7f5c713bf7d70b3ad24839d6f91aa1"
    sha256 cellar: :any,                 x86_64_linux:      "c5729b7727b7621d31daad132d38648d54cb40cdf3d55a31dbc9a96f5e54d9cc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
