class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.16.0",
      revision: "042efe2f696b71adf9db5b14fc28cbd947474faf"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a9a8218e833df94b22cd3197d79d5b3ff3f41160e040a051913edcaf57cdf22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f416849652f135c016a150d22635a2433d8633c0a1eb0bfd1548b89b89c08057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06a65edf826ea9c76fdc680adf17031215ebe177b18fc717d510335c743c12b5"
    sha256 cellar: :any_skip_relocation, ventura:        "f5445fd023d6e5e4683d63ffc499df2277faeae1f178bc764530c9dab10b28a7"
    sha256 cellar: :any_skip_relocation, monterey:       "21bd0a5526e1cc22bbd068eaf0e133ae23f156656891385bc33977806b9e4b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "798715d45ae02a87ee8d283fb06e674337e1b9704be201798100bd649f666f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad1a3780e8c0831ec77d796e4ece47b6ceaba61d0ef6130b4b275d1d1418346"
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
