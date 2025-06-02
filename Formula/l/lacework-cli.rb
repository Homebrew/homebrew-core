class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.1.10",
      revision: "440ad70d1542465900fcb65af669c7c03596f87a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f63863b99cd5c77447902d3925d83c82c4d749a26e2449ae95ca3aa4168e911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f63863b99cd5c77447902d3925d83c82c4d749a26e2449ae95ca3aa4168e911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f63863b99cd5c77447902d3925d83c82c4d749a26e2449ae95ca3aa4168e911"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3edab0b764b3b2748c51488d285e78f7d7924e4287fa396b56ff4179c9dd836"
    sha256 cellar: :any_skip_relocation, ventura:       "d3edab0b764b3b2748c51488d285e78f7d7924e4287fa396b56ff4179c9dd836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0b89651613f7b35454546cf8af7a0f7172fafb5b16be998277714acacbf6d9"
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

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
