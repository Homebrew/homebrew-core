class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8fea360442ced9c2b380871e64af20074bbdd47ac5109ecf7bfbe220bebfb7e8"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d8762c2fdb17577a613990a929340d8b0387bd2913ace66c796f7c5f8ac452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e588d7e079e318dba66ef1253cb00944ca3fc3681abccbd029c9410df4a39e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceebc4d9e6184f2c70f4abd80fd1e0f328040562b6ef024be603f72de8719142"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb6c2c80dcc564cf649b276418a9a8d8b2d1f5a75fdb6cba9ad66b7876dbd1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd55b4a7d5f8cd665b946bae3e6e694303ed40d40c820278601450f4f226a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2415fb46bcefa505f9adc6823be630ac2e70043deef2ebc1b5d57f5de06e212c"
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
