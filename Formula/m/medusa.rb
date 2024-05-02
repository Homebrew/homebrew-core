class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "d4c6bc58f2ee51b93007cf678cc3ed07f15317a892faca3b4098c30afa4e537f"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/medusa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ff9abc0279a369078908b052d84a9f9739b375553004759b2deeafe9b31cdcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23637a87bef0cc653f8b92e4e91968ba27de2bee493723029513c83250af2df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61266bb31d5f8e9dc4b93f83a8e88b5cf7b66fbc12ce24e128e4ee809d4463f"
    sha256 cellar: :any_skip_relocation, sonoma:         "894d95c7dd1f762d09ff97b6406e0acdc8b4475b4c2a90387dc97067ef9817fb"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0b7e14b74bc60ead0a23dd23ab35c5f63ea606243c457b03d584b991c8892f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9499953040770ed79f4b4da6689de62dfa484682b11b04ecf360cd63804f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abacfafc77be6096ad9f2dd5ee2760676e8c3e0633b30c2f02f12004ce4d3543"
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
