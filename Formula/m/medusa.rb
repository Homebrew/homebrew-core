class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "5ccec0ffa3ab83de3580ba040de79fa0fe88832489f9e0760287748d5f57e572"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb4461af0bc9a1c32df596684ace03c4036d99170ac7e95d1b90f87aec39512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c244c939c57d60c2fbb92114e78f94f3a1d789bc4df33641c8be627143648a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a081617e9aedf70c6252b851a4944d3202c220f8b89b79c31bdcc6a4a71aa783"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e338851ebf370dbe427de91d9a9559deb017ca96ec91883903185b131ec718c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bb525cf065e0afcaac2b8990fe7a2d5b21346abc8030b2c857a32e4aebc19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1cdb438ab3ea9173bd0d47f9b6ed2c5cae6e9e95925f4e4e014eb2ae1b8fa34"
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
