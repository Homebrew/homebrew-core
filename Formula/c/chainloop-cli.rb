class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.80.1.tar.gz"
  sha256 "ed58c5398378498246702c2b9ba61c9a0075cdc47c71487cd0502caf40f49d21"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1df832f599e3f8822b832657d2e6a5748b1dcf102292351d416ca2564d79dfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "519511854c6b6a16fea0d6b548c78456a82d2a800dfa4d85b20cd44c6a8c8a22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3603d933593d33a21350050a1e164c8a3d1fbe9713d9245ce79d9058a3af840e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dea3c3d49cd38de3b1dd651b034636658a7537749b51a2672f31711af709bcad"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd4a40304291f67bd68e856530c9665e25ee198807c7036fca2cdfc18081c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "85624e4cb339c8baa3a09e9420953349154916b92f4daf7039e32162bfb06bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea2460dd876ea11cc4a59837c8f811deff92a2ed88a1fe6520a1313d03dd639"
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
