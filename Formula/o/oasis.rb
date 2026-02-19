class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "d18e84f2de061944b2e36b6842c7841463c3c448c318c141fc70d16c92cebdcb"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b982e50723c6016ef59e6db9fdf0cb1ddf537ab577f88fa53ca8a140627defb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab9c4eac4d8ffb574fb21b9725c7ef7c8f4223f781f6a75eb1cb022ac54573f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3819c779b1e76e3551353e2f4551c774ee50f1fc4f468e7e46210d54960c8f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "534e7647c208c6bee42d6bbe6857f0065b3abf1f113bce98a149da7f30f68c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a690519770595018b3f856d2823dc5a34a7d6abff7a430e317ce2c12321503f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb090c4ccc359e3785658125bc0844e2069ecedb39ce9668a69f5668b4e7b8f"
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
