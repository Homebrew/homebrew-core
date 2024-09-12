class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.8.tar.gz"
  sha256 "f567e9084df528376979218a712f46dd5b3860d152840e46039102671c2bd3e7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c74bfdcfd39dd52ff8ddf8e85b220fdb4f217263b4eceb258dcdc61f00cce89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c74bfdcfd39dd52ff8ddf8e85b220fdb4f217263b4eceb258dcdc61f00cce89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c74bfdcfd39dd52ff8ddf8e85b220fdb4f217263b4eceb258dcdc61f00cce89"
    sha256 cellar: :any_skip_relocation, sonoma:         "437a95c0e5b3d86d6d9198ae1eeb18e9ae15226d3fece652dd5e24a954c84c90"
    sha256 cellar: :any_skip_relocation, ventura:        "70e5e06cbdef911aaa7db413a4f1ac00e944bc462449af1e59f674910c2f6338"
    sha256 cellar: :any_skip_relocation, monterey:       "595f886b8b8764a4365ab0a90797e2901d0e962521810257c089be84c44bcfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e33f577d84ce06f9fd34d4ccd4d31c5f60f1590173ae96a5321345ae059114"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
