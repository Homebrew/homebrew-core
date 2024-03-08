class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.47.1",
      revision: "29027f5570cef9777bd3bf8a946109a7a9c840b9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f63da2a76583bd99f53b1516c7d8981abe7c5165ba35e558ae633a7bfa1ad030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "619044d59d2e8aa31007bec43d4197daf67a9ba776d89fb03343d47112160717"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c622bc2a5d4b4247472eef731ad170fb124414f880eca8818eb12873dc87c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9788d4ab5c258e0b56db5520123659ae97eb81e14940bba9605978ad40dd5fb8"
    sha256 cellar: :any_skip_relocation, ventura:        "efd70e8bee0d30fee1b9b82d2486512e2f5de4dd02b2578343ac4c4b7195155a"
    sha256 cellar: :any_skip_relocation, monterey:       "b58534cba7289d3cd8d932026fb8001d19a1d5f2a3045062efeafaf589ad5da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da939fea7f7d53930c24a5982ff0c86e6d26f7801c602c7d5df00e89d21b5a0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
