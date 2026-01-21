class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "ee111ac9ad50485862630106f0d8e4eb3a59f72f6c6a3efc70a287d4c1729ee9"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bd0f692554e948864e6dfcd324c777b1fb6e3c29868d558a5b2729d9cef17c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b9649684b6746964f7723a1bb79e10f5b39051dd8cc941f6f6b51a7196c025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "515c918f552e8df1e3c17ebfed83c522a30d19ea62695cbfd953085871a7ba54"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba8e83b1f9d771e9d56386a831e78786039e3a1e9514cc582711a7b5edc2399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f877df052ac2596fb1bfa11c5583894ea4f6083a36dd055d8f1c91974344a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eecd584537f4629eac282489a13a58d3355a07421236afcbf45a65cb056cc640"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
