class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.47.0",
      revision: "1b7c7406677d52d63a90b04b523fb2b2c50d592a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea5a828ff34b331955a9be50833dd0a8faf66ebb7e5562768acce32b87018b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5e746f392a516d364e149f689a3a17dce6e2e2bc8b1c1324a9f978d6f690e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc83e1b3f4d8a0c6deb358313e47ed3502a298c66a871b8afed1726495d9c39"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bc3edccdb502a116bae9d77fc01ef6450efaf63c7ecd3909e9eaf1ae648f87d"
    sha256 cellar: :any_skip_relocation, ventura:        "9d727e7876c4f507b5e7ec74396728a6443fdfce89b0ae48433dc1d1a18336ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b9e6df48ecd5778d85530aba5cff8dc47251834e7aa1d5d00b7721f2a3fcb770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a483c81f721bf69ec0e9fa5f60681954d37b02e6075ed17ba0bc4db5f6b1efd"
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
