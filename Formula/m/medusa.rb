class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "fb427e922eeedcdf171cb9181f7db6b5ab47b2fab3dcbad000cf833fa1592130"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f4f8ee6c825f3410765b1206c1ed2400adf6c5917f90b6a1b31098ed9aa9fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55669251472eb968d7371ca43fd5d87c9f95ac572a7218b0b8242ba9bf8e80a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e8120b2c49e2b9a0992ed30813fa43396772783b7007e713fcb6aa7a7688df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "725187f724421b05db7d16428c27852f5915c8c059de085ea17b71e8368ab589"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1be22b56c71b4679da39213728efceed14ee3f95314d24c8eb95b7e100334b"
    sha256 cellar: :any_skip_relocation, ventura:       "c509bc7db13c99b59d46998d6572860ae60e22638063dbf08184268f379b3da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7199554c43253f8cbdd5ecb009cbb29b609f590a25ffc578c10c8856761b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff5acd8ce3c46c5993d6d1aac9947624033bbc56ecbff589ea3ad96a3a03dbf"
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
