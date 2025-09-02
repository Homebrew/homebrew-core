class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "4d24b39765c54ab7e93d0241721f7b8fd8f9a39c6a6ce6503f58c40838af6d04"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653077cf2adb781c944f60b97a703a77f2505546d4739d549b42b76aec8a680c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838bf24410468a3a21588ff2881ee12a3bb5bcb25b5cb370603729ef805cf325"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d100abe934cb8b413d28d6361921b93bd324624499052361aebd33a3def1c6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9aca8525f934a5e46dd7faa9f2b0e3cea2053295f4a24e26ae02751ebbdc22a"
    sha256 cellar: :any_skip_relocation, ventura:       "a5ee34a965cbbee31a9421f55d234357773b89aa9ce7e843078a7e06e4207904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad824e98ff5d2c72911d161688266ff0f8cfa1f4ba034f575aa4a7fd9be4985c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989965af1ba7226442096d4df7f286c5e0ba04f4e19f0ffcf8ef2855a0eb970e"
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
