class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger.github.io/firefly/latest/"
  url "https://github.com/hyperledger/firefly-cli/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9cde332c2afea87b4f363ce2a556ef863ba31e95b1ee946fc517da2fe0ba7583"
  license "Apache-2.0"
  head "https://github.com/hyperledger/firefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e101999f5d8b27bfaf00e4822e13f1b31ed099a2917236dd1bbbb5de867b15f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e101999f5d8b27bfaf00e4822e13f1b31ed099a2917236dd1bbbb5de867b15f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9db7722ad8d9636a1563900fa6d100f4278d265a1b817a7270390dc24288ec4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea6aa3be782ff5689b8cb5b32defa20e31dd55a3b13f79685bdbffe8e26d7d80"
    sha256 cellar: :any_skip_relocation, ventura:       "ac34aa5129b946ddc1acd7b1b18f750cc8c7a5fa45e984b0d43c681525c9f632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0034f50fa03c4d36f6dd4bbb7b0a6ce3cf977e544a853de00ffe98881b589ab9"
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

    generate_completions_from_executable(bin/"firefly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
