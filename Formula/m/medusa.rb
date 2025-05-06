class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "dc1d759a0037350b51adce293cc678bf441386606ccf622745e8ff2d04a86cb0"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a87e647f278b365177ba8493606325a91557de070e7f8e1346cec0854dc7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ccb12465609526c2dcee37bbabffcb38affa4f5c9b5560d77b1dc270a996b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1f7b37a0f797128ba0a10bcc296fb75d2ecf3097b51d37b5aae1029da4bb4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7549c4a058ea66ba043d5e66dc312f2f401b4ef3fad6ec5e06123036a93642a"
    sha256 cellar: :any_skip_relocation, ventura:       "88830664a5ad9f7075537f5423e414cf287e93183209f1518fd153504cde2533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c688934508215e0501c484964785c04174f89092cd564951d2a9406351b0804d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8dfb057a32ef14cef7b32b4b62970d18de576fd31a3bfbfe9ca42f3784ca93d"
  end

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  conflicts_with "bash-completion", because: "both install `medusa` bash completion"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    (testpath/"contracts/test.sol").write <<~SOLIDITY
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    SOLIDITY

    fuzz_output = shell_output("#{bin}/medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end
