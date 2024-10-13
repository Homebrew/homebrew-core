class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9170cb72ba0adfd7762cc5eec122b62912cf7bbf1376ff4980f796e9e08d67ed"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4fe692e1268e471fc99d44255c9ea21d2abe06a13d8296adb362d0d379c88d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71cbc01a3df8029c49364d6eec8394769f006d49b46ff817c9e7479eddb6725a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07dba954197bf45222d566e64aed15e6f9e455de1537279d726a7301a32780b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676975599c4e33681c3cb7fda6fe61acefa8f467232c41dd94d14d5614bfa23a"
    sha256 cellar: :any_skip_relocation, sonoma:         "73e57934ddb56e5d9af8bd3747b0f752fa389d4aa40e4dd072dc1cd071768ff8"
    sha256 cellar: :any_skip_relocation, ventura:        "3503e59ec34413ea894035c56ccec63197b01e9ac50c277c196331c62df7f67b"
    sha256 cellar: :any_skip_relocation, monterey:       "d1076f1a85665251e550e721b645f5dc6a1cebbc4b6c5b16fffaf1995e5399fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ca13068a4801ffeccbcef9409bb11b12b7f4f82e2184620832656fc0826828"
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
