class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "af957c075914eaaf432f9789724ed6596d437a48915d0fae62e9d19c1523ab5f"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b62bb2ff5fe23eb6663679295df39a98fe14021744496b927edb2a7dbf27bad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a8e9c3b9bade01fc651a3004d8f2326493e83c6394b12cf50a35de108392c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c418c3c7867264461fad3c5bf42081f0a429268328e42801ec157cdc307d179"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b87bd7f4f102f158f5a2e85b5f8d0510141a8f30fa9a69d2f1a15c09ad8ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc30f7350428969f4afa42ceb11ceba0cd43bd1671df3735c2a579f5677c488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291191270458fe67e74e180579fb7eb66e9e626b9ae6797cabecaff0597e14ea"
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
