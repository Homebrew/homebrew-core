class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger.github.io/firefly/latest/"
  url "https://github.com/hyperledger/firefly-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "05375efa4e849695c60e70ec3e332b7a4c8dbe666f1b76b8de3f12944b85b60c"
  license "Apache-2.0"
  head "https://github.com/hyperledger/firefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adbf91b1583f58b9cdf99e5b5f4702e7e382b68678d1a65038dac45a79d266bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e65c9e835856a687ce4758d8de149fbec354041ef361e19bb16a29b44a55c86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dde58aad5d6ce8e08b375223c5632a992f15dc010ff73db649d00f5d5fc94957"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e58a9911ab5d61f995508662d10c94c6f75f9d4dabc6297e8e830b76130fbb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8487d1cff3e216289b07a109fd41186c425d789eed7921e354c41a2d10bbbe60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14926594845c1055febc3c85ac56b950804433b2cd42014731881fe414bcf6c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hyperledger/firefly-cli/cmd.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/hyperledger/firefly-cli/cmd.BuildCommit=#{tap.user}
      -X github.com/hyperledger/firefly-cli/cmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./ff"

    generate_completions_from_executable(bin/"firefly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
