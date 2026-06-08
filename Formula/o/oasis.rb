class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "610411811d5d5b964c9cf0e67f92648474ac3cfde2efd28b98a67d84b486ebdb"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c881285a2dade84b7e9dcd78c13f49fe6091b1cee472ae39ba24a43b7a621f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdbe856144e718b64eb71a7c050224aa9f948e84e79a453181387928fbcf9c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874cbc5da9f5a1ddc06eaa652863eab4f445e59cf1acae624bc7f7cbcf2bdd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1ade713897f6738f366998bc79ff598818cc3ce83ed58809b61958b1d22007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6cf0c0177223a57495df7457c3004a2ff8c02c5a9281b1f061e7e328f49d199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6243fcfc7854579cca9eb0a9506eb93842df0cd64ca418dc4bd3f7220b528e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
