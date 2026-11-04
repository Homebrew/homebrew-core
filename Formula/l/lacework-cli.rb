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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8294143bac1b9d52975a851fd224f49007cc5828fcea4d9969c2ec0041e4f9d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8294143bac1b9d52975a851fd224f49007cc5828fcea4d9969c2ec0041e4f9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8294143bac1b9d52975a851fd224f49007cc5828fcea4d9969c2ec0041e4f9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33c5f3ce487bf2b2e215ad94a6abf3c1be6d42f695d8d6a1a631c117d553fea2"
    sha256 cellar: :any,                 x86_64_linux:      "9ad93349bc371b304370ab3d7c6a657168fc36566de166e8647cc033a7e363bd"
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
