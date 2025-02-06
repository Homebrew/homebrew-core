class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "835bf21e8f70681e4050d4bbbef652fd9578329662ac89e988a09cd254f77d57"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7464436fa076f3438f18910db7eb7cc236ea64eccbb54d406cc7a527947aa3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c4070bdfb76d913465df89492a3ffeff165c61809df9c61fac6e9b6d8d701d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86dc5a41df23b414e16b37b9bfc0d3df1f50d2583d24741f84a7a32048699ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72c7002c2e21ac1d059140b75dafcbae21c3fbaa16c30a95bbbc9ef90b9ca752"
    sha256 cellar: :any_skip_relocation, ventura:       "68e35acbe433bb66719711a1bc43b8a0332f03c6adb0f80b09304c32655a1ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91342ab818718f83051cff128c2f95deab6bc0a8a86eecd27db8c8b510fe1c80"
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
