class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "91c5343cea9814cf8b98d585a3f097582c07aaf8eb93ef3148a8bccf3c2001f8"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae715cc8b968ca0b12b72e22ebcbb2f9bcee37bebcda4e4ea47dd687c7661c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6efd1b76a3bbc3327362f490818a6bc1d88875f314a3e7745552a519039112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043f3ef876f94b28f2b08db901e951e3c7710f2ced2e76104916c29ad7e143b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "334c38cc24a00e2c916606c2df7312967a3a8338351bbca598c5411a3042693c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8067123b1f5c2e83ce7092d7ec1c89a3f1096a6c8d4434d86896ff55247ecb"
    sha256 cellar: :any,                 x86_64_linux:  "f5e9bb8b7bf9559efc1f4d13cb9229dd7d7c870086ff634f7ef2b15c5994c7b7"
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
