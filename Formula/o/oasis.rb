class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "e585ad87b74eb8cf58981f143b31eeeb0a371eefda0729c3f7698a4406f7fbfb"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acff5ad6a870426535aec7b5af3b33650c4a04fa27114289c762a1dce8781229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4963f9c737aaf5b2ed1d2c7819b99953fff775b18978a54f6af219bab63799bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95680efeb39895150f1bc590b3d56ee8e117ad7f8b23552326e905076bce16cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c66269cbaead7fb6f36445a91c2528122f6d5615bb645294d572feb68871490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc1ec748a391a1fef747468ac0830c25f7f0d0cbdcb879e53bda0465ff8da692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c781b3866a6de91a28a1197629c5fa653fa6ebc9c38d199314282766e5fa32fe"
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
