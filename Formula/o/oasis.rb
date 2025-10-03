class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "40ec45e8c1e90436e5b67608cfb8eef424bf0ac2ee70fd4fedb3b5fc43b33e02"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd1eb4bceaa55d3172768c53c7430cbd80e2a816a1bceaa7d74ce3fd01daed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3819a412f4b3c56dd2651db0cd1ff692e88d092c3f9954be3ebe50a7fa95579a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60c452eb90ce9f9f33e4101daa94bddec6f55e43ce2494ad55a06dd68badeb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ebc78bf4b0bc8ff8972138713b488d9a10dd5c373487965049c48fb3a38c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4601935435e4febe6317107add544d1c0b282ba84709917144c3400fc243757b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c070d129fdfd9100ef31f99084f9b7ac647b65cc580f5acec1d5188fb4ba22a5"
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
