class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "e1427a7893fdc5064b0dcb61cc1ddb5f48c30c7a35f36982f291a03b095384ce"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f8eebde266cd3ef3fdbd35798c4946d506efbfbcd3b400552d16f0739f5f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ec19fd2a3362dabb260c67be40ca47163a4ff4b44cb8e180d9f77ff5cd871b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f55e98120cf9dd520e26597640e795c4512adea2abf7eac16c87c0482ce6a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2940b94ced59a657c273c99f4c9b903c45299d4243498b2e6e31bfb19f776464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ef704b3caf06cbe167a9b47b6b11fe57f051506d731d6bd5fd499d67bb0990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ff34f83e2cf11cdd7420c2f3f176426cd08a77c7326c6aa68cfd95a3c93e1b"
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
