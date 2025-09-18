class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "d6e6f64469607400307c0a4f4da0f6e369f5d2d1595173cc10889c6d5f2a48ab"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7794efb7e41374684e9b890b04cf737ae16b9ca015c0c797e26254fc598c6805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d01580c1501b1cd3752f87324f0ca81313d3bf24f7387690c888ffb93463414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162ce127366a89fef0e394c85c01bc4dc2efef98b6c0b09857ee9e0e5985c62c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b23fe916b5a85ba8caa24f572e198d3fa03d1129b416e19fa42c1518f3b5cfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1447b2fe65b2c85f26fba4d2db3d4db1a85202eb3fc4af64c140df37a4d5dbcb"
    sha256 cellar: :any_skip_relocation, ventura:       "9c1bf619cf3c087ceb06cce259d2ccc65025a1a9d8d6af5a2111d7aaa812b11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b81d2c10ced24d1de997e1062e4826ba4dc4400657a2f77abaf935c6314e6e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06012713afaf28f551c59cd299e7ab4a1ecfa3485863b90fb6c4bcb5eb79934f"
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
