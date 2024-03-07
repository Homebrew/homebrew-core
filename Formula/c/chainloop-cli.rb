class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.75.2.tar.gz"
  sha256 "147e946dd6783e077dfc6ed467e7044cb931856051cccc258f195d79f1472a4a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fb7e36e80e3015a0f7b423dd7b01d63748ef8954ab16a25aa910900ffab12c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ac0fcaf4027cfbbc1be0b050d5d5f55f935a8d5e206ae95a5b289bd8a12e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69ba30c67ab24d9fb9f21065ccff21cbaf6babc8add9031976eca20165e3ac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f26cb7924eeee66ddac58709c8027abfbe9163fb1b9d2e29d578923d43cfa35e"
    sha256 cellar: :any_skip_relocation, ventura:        "dca1f433ad0a16df72e0a339893d498a4117bbd536a5d3690e059b4903069377"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe2fc6fe7588ad87446815746f18323d4c3588039db4db52cee81b67802ce74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5adf1e26bcece92b52144409d0604954ea046ca246236d31e93d79177537db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags:), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
