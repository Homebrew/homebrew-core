class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.33.0",
      revision: "f09ee5afe451285555619b72b62cc6828a5fdbf7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fb6ca0e4e69dccc718ac850a0708f48015da8cf617277e7cd7763a8b8fbfd85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4125d39460fdbe33b08e8f2971e2ccb5b20b2db96a87825fa14aa4280233d33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07510ca02d8bb77ac51ca9fc04dd4d403ca4d46c9453a35120a51067f2d844f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b089547d4903df23fcd55815da7024316cdb07e959806de8f533ac8a41d50c56"
    sha256 cellar: :any_skip_relocation, ventura:        "79c6b1306b8dff44d7f0bcc676e157dfa36eabd0b2ee2b0c9a8b8a1b8e383c86"
    sha256 cellar: :any_skip_relocation, monterey:       "71dc01d8553316dff3a38f528f055a919d95609a4450a23b59f2562a3c38bdef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c5cab854c207850172f8143477be786909c50ec5f786fdf0294b5b40e8b767"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
