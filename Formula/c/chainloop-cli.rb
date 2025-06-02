class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "8848d871879d03e6774e02f18f4684ebf2a15f7ddfda07866f6844ba63b27e1c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80806496cceb856f56fe1a71f4730911e2b436f11518eedfc418a50ea3f3dd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2584593060b51c22b248d33f83713320d6950884d4a2a2226887efbcec5050"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a2a0dcf7c7107ad5ba7f9e103acdc7d099a71f4fd4fb7e88532c6cec57e455a"
    sha256 cellar: :any_skip_relocation, sonoma:        "550be51cf4b3c3fc851776e53d20852936e4c0bedd9c255e088fed6776834bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "a9b52976b80648087dc94694cd8fbed415dfa5b28587166ab4b526ca0fcfc060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "525244dfb049cf021df04d379bbdf521b86995a250564cec5563c0e53d29bca9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
