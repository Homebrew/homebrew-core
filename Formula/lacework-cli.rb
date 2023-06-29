class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.24.1",
      revision: "07cdab59ab2d65ff46dd6a8e8d942619d8ee906d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c71b1ec8db42a22b98472f60b416f1c97983139068c35e5e2d63d6176b76696e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab49d8c2f9e775fd7cbb2d4bb8d30d8d070cca556498ccbc091e0f7bb8376f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd233ff8e2f812ec4fcfadffe4909b4ed3afa71886e863778d6090ef46a438d9"
    sha256 cellar: :any_skip_relocation, ventura:        "73ef1462302c3ad25cf0ac735ad02566dd375dca3ec66f0b3237288505448dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b72ee767d3586c22926684e3187974727b308ce9a31e267c25c107404a1cc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb8eef0279de82fab3f5e02f026976ae3f492a19988a3790b15c6b667e7e7b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65079d84eed20f5f9eb74ce919f0776180957a4a7798a3acb9a46c6b308c0ce5"
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
