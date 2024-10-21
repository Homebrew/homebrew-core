class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "f8b6e55541ce4443d6f07ba6f2394148809691cf8c68037bab0ec7ce742ac2ea"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf0e9f52c0333eb6fcaeb28184d0bba54511a081ce3dfecea84e724292a3e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45549fc0fdfb15714d2ab270831a7ee07880ecf5f6d92ce2ae220c8a79149cd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60ceae2a39f6e40142f6f2e70089bca3fb63641ac187cfce319443bf8cee290d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06dd2192d804a45acee223d9dab41d5e8cdbefbc23fa7f2b49b85df37dc5eb68"
    sha256 cellar: :any_skip_relocation, ventura:       "a174a0fc2689a2823cde31885a537f37f3d217baf585e3514f3b2ea9868941bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ebe2c5fdccd5f0897a2cd38df166a6d53e0b439ef2eaed8c92ec21880c3ec4"
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

    (testpath/"contracts/test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function assert_true() public {
          assert(true);
        }
        function assert_false() public {
          assert(false);
        }
      }
    EOS

    fuzz_output = shell_output("#{bin}/medusa fuzz --compilation-target #{testpath} --test-limit 100", 7)
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end
