class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.95.3.tar.gz"
  sha256 "bca56a7ad4a21981f547fb61df4e6a5d3a379a4e9a6d48f75415dc911e4a8009"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b528960c42609085ea5ab8e23433134e08647f01a44a60449539d6ac59dda566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9b87d7e3477c0af12306547af358bd885ac2a04b5ca18bb2438de76c32c0968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ba469f4a22d30e15cd76e8d9d1609cb402470a78298a0689305b6807a8f787"
    sha256 cellar: :any_skip_relocation, sonoma:        "11265da4f90760af7e141f5648d6a80b1caa3017a6a206e718bda7174a46b4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f831f0fc0df5a7cd25faf4e6706bec0b87dc7794f06e36a037d211efa10f0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d55cf6b114349ea39c263a001f4397c31e89688c44505ada424de32399839c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
