class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "17d3224f4f36f60c49730ee7bb86296536eba57460d62ac9490b3fb703325338"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6b6565c5885c986319bda7b4dd8683df8c09f8ebe763b0b5872b9a7221d39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8060a4defcf6917152446c6b02929633820799c281698eb21031b5cb49bf501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68daa7c76c5f3426df706d6a7b96eff9d19d267838258e8ea8eaae086eced453"
    sha256 cellar: :any_skip_relocation, sonoma:         "5be534e6989faac0a41ca641de6b9a1c926b8549b883527046ea693e7e5f7bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "e1317552308bcc18f6602eaf8402d8ac19f6bbbf067e9ea182647203f3ad3abe"
    sha256 cellar: :any_skip_relocation, monterey:       "168370569fffbf8f559486d997a175c4827f72f57cea92c1e7cb237d98cf55d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49899c80c00b7c0cbe43a93bd627af745af0a8a72a852f85e03f76454f40817d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
