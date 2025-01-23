class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.152.0.tar.gz"
  sha256 "19317052e175d4de412f8e6cf5f54b3691dd6517f63f4c81bfb6384909b60bec"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958d0ff97f3b857896836ff25591e48a29cc5ed80c5b7147815883854d8bac4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958d0ff97f3b857896836ff25591e48a29cc5ed80c5b7147815883854d8bac4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "958d0ff97f3b857896836ff25591e48a29cc5ed80c5b7147815883854d8bac4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7059519966a4d7cf282d1647abb64ed08ddf1ed4b0cae75348965447b65611ff"
    sha256 cellar: :any_skip_relocation, ventura:       "e8553f014d6dcf56e8a9f16fa4d8bc772767368d694b948ecb96562391cd18e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ea6af3ead6f9a916cff2884b299b2f008a7605a1311f754193d0983441680e"
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
