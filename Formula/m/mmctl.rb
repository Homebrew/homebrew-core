class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.10.0.tar.gz"
  sha256 "1adc659e1cddd03e33398981c23ae5c88dbee11d6c01d66c58b5c715473dd0b7"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ace3e7f9908d6eef37d03257bd0ad962060c741a235bb4c10caa9758fb9bfb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ace3e7f9908d6eef37d03257bd0ad962060c741a235bb4c10caa9758fb9bfb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ace3e7f9908d6eef37d03257bd0ad962060c741a235bb4c10caa9758fb9bfb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90be55026f815364ef99dddf6b483984d45105368d8303f1a2437e89130f396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa98c52b5c201d8a7f29ea8fb303d4db945aca64d7f6437af2afec184909235c"
    sha256 cellar: :any,                 x86_64_linux:  "90eba7fbb5e73b5b0635ffd2135187574f2a8c43af22aa34020d8b5793b88de2"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
