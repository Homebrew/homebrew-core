class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.7.tar.gz"
  sha256 "15cba570d978d43471ceefb6291de57f14ec1a14d6351dd9de22708c77007cc7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfeb8169f3d5af7e84b99aa75874680dfd089418392fe0e2aa767aabe82cddf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfeb8169f3d5af7e84b99aa75874680dfd089418392fe0e2aa767aabe82cddf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfeb8169f3d5af7e84b99aa75874680dfd089418392fe0e2aa767aabe82cddf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d375a10c9c4a81790f627e1e488cfab41697f704b2f4711e08dc021a881a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9edb18596a4f6b049e9990737eb9ac8766909efe2ffdc76051c5a86382495e14"
    sha256 cellar: :any,                 x86_64_linux:  "d928621d9fc3540b37c97d126097183916c450078717fe49a9c1f7b5daa87f15"
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
