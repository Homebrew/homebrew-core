class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "feb4ed67569d815928413f39a2ad384b32c41169fdbe8fb20745b4ce7f16e547"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d7aad6f5c99d16afe05efbdb040b401e3b9dcd2961c0131ab32ed21fc06ff49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8dbc16e931d20f9f3fbcf2a45c4a451219c4e4363726d28391eedcd4fd22a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c80e16baac5e3e130081cc0790f63d1b67031d556732d66c1def779fc43abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c034f6d3070720ee3e1438ba43d62fb9b487475dca132c3f2e66ca2b4336447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2ce53204c4ec4168b57f9df84adff865666d76bcf1180ec6368e3b0415f0b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e917e3c9ba9bfe3d0a1ff2a5528e5827811bd3275cec16df818715a21a19f97"
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
