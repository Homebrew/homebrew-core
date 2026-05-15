class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "075c080a52cd27f3efae4146ac2e1bb38c8acf7a58891dacef610d29e91d93be"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171577dd8a1423ffcb8e8322e3f6ff7372f06aadb500e5fa947e01856c046df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74b21070cf3a32810e5729a12625eb5aaeb308b56fe40157a5d4b2ec3de1053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90b9bf4570c49a9860f61627fca1ec1fd9500469df3cb049a7e8fd45f6337ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4475b58792b0a2cb28549b69cc11fa8b6cebb19e14fadb06f240053a310f771a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f2808967ea59f2651dbfd5315ca052d004b18989a46c5a96dd4483e58e7503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602048de2af9385120c31cc1846b48c56c88f3236b12dca86ff389ebb04961d3"
  end

  depends_on "go" => :build
  depends_on "solidity" => :test
  depends_on "crytic-compile"

  conflicts_with "bash-completion", because: "both install `medusa` bash completion"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"test.sol").write <<~SOLIDITY
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
