class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "b69b9ed2731c50416e455b2bef613663a1e7300c73d488fb827843af20cfa048"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3ceeb0f28d2c60eef17b0fb1129ce1af7f8929f745632367d99685d5f244447"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e5fc93ecbf1514b370c7de8a8c008b2d6670234aa8729ca8f4ac1115eb5cd44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8af3c5d4b0439ffa2c901cbbecd988782eb67ba6b120f8ca25b263d4dd90e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "176fe785df6f351dca7145d70f406b71473894f6376803a95888b4c7676d9848"
    sha256 cellar: :any_skip_relocation, ventura:        "271d81436139a6d350adfc14e4c4f391d4f00f36409a36deffaedea71652252e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f190e73f22ce081a7464f14e928880d23f9837959f386e024ef249c01bbd643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c77a073a04b51c69703792daf9a09a343770ade3196fb9fb4fd95b297e84ae2"
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
