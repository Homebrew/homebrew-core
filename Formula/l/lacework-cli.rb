class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.51.0",
      revision: "63e71b0fd8e96f606ed16de2fdb4bfad8c44cfec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a44454725aa84150c88ddcb2d1e26a96202db3a8d600ad1e8bf1bb324ee645d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd4384456ba4e90d724b69eeab2631cbcfc5770f7ed6636e7979805e8ec243d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e4feed013748addfb72320bbf3528e2d93e5bc16cc4dd1cbe7484c50dd5d04c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d09db30cbfe3a47e6c9e5a9cb83468066092ca4b2561ef82277bcc37363dbab"
    sha256 cellar: :any_skip_relocation, ventura:        "733797abbc02a78808af2d9e77116ba0c2feb243ce21737bdb86d2a4f441de16"
    sha256 cellar: :any_skip_relocation, monterey:       "ce66bd99da93028ce0cabbbd6f6bc4a398cef5c61f2211af5bd576050b1449d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4658d9e62690b3a3443b09deeb92a026624ff87ef281859f7a9843e888b92a"
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
