class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.29.0",
      revision: "f64f644e99272c62bd5782fb501f66bfac119e7d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc13c6418ab5956772954a967c313e224701639e2af33a4295662b55f82afbf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ceb5cab259c932070509ebec0c35499e8b6a4559d997b759f129c4699d5696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fef8711fbec1fb749172989380cbc7f86bb4fc90219acfbc8d93a31812e6e1f5"
    sha256 cellar: :any_skip_relocation, ventura:        "7fda8a1e1f097092869c63599f86fc63f25375dbc8f703d06bb6bc7919980272"
    sha256 cellar: :any_skip_relocation, monterey:       "995118edc80defed426331109f85fbd51b2458603545b129aa25e8f759ed48b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "186d2fe166b9b456cca6a1e96dc3cd18d488bf99157cf918397d8ec2c665e05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7ea7095c241d441c0ca9fc2cbc9791707d670def165f9ae0e24e7ce300637d"
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
