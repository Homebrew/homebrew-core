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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05ae1b12c286e6ffc8fa7efb60c49c2da9c133efdea23ed06005b10a11e70b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4b4f3cb9ca964632b7bbb66e155ae930078aa004a7fac1618f5f8e4a50fc72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7687f86144ee7730f3c7c916c865251c2e6987e45346b9c1703e38222193a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b840b0eceb0b8c0277037084623577b546f03cb73e18fc522ef32dc738ad8dac"
    sha256 cellar: :any_skip_relocation, ventura:        "52c54b96904c233dc69e122c8c89c4997d63a85b81a27552d24cad7a1c9f4f0a"
    sha256 cellar: :any_skip_relocation, monterey:       "0d1b5dc2dcdc81cdd81e0e4ad152acab47ace470527f8d92f6354fae16796786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a834c5eaaea55502abdcd27e65754aafad4cabdb1ac07bc88d4c15837a65a5fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
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
