class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.90.tar.gz"
  sha256 "c246439c7a60e57f332d0ffd478110441498e6f266ba21865f78dde328244350"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391fba831818f9ef3af511809edbff6f3271fcbbbec1b6ccf2f38d5ebac72885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc1e0e921d86036c42a16800918e0208c0c83a0db7943bacd467651a55888af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc1e0e921d86036c42a16800918e0208c0c83a0db7943bacd467651a55888af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bc1e0e921d86036c42a16800918e0208c0c83a0db7943bacd467651a55888af"
    sha256 cellar: :any_skip_relocation, sonoma:        "93966e5d89d6773c2ea5aa40d1ed1ae9b061ad26430fbfad933e3bfe0d71bc44"
    sha256 cellar: :any_skip_relocation, ventura:       "93966e5d89d6773c2ea5aa40d1ed1ae9b061ad26430fbfad933e3bfe0d71bc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7580328aa751528593135df1a464611d3e1d2559f7dfa33ff60c5d5e417884"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
