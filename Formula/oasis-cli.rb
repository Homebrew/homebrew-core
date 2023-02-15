class OasisCli < Formula
  desc "Official CLI for interacting with Oasis Network"
  homepage "https://oasisprotocol.org/"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "166d3b42fbec95d44b57eb19ebe65100d9b53b2ed45b4cb85409fdc06f8379a1"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/oasisprotocol/cli/version.Software=v#{version}")

    # renaming binary to oasis, since that's how it's named upstream
    mv bin/"oasis-cli", bin/"oasis"
  end

  test do
    output = shell_output("#{bin}/oasis --help 2>&1")
    assert_match "CLI for interacting with the Oasis network", output

    output = shell_output("#{bin}/oasis accounts 2>&1")
    assert_match "Account operations", output

    output = shell_output("#{bin}/oasis network 2>&1")
    assert_match "Manage network endpoints", output

    output = shell_output("#{bin}/oasis network list 2>&1")
    assert_match "mainnet (*)	b11b369e0da5bb230b220127f5e7b242d385ef8c6f54906243f30af63c815535", output
  end
end
