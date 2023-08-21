class Medusa < Formula
  desc "Solidity smart contract fuzzer powered by go-ethereum"
  homepage "https://github.com/crytic/medusa"
  url "https://github.com/crytic/medusa/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5ba7ff3654b229a44684f473725dd7256e0514926fa553fbccfa556e399b3c3e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d5fce00a1fa24bf839644fe2f009a2c2834f4d5f0a4588ec88fd5e23272c5ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348314d4db83f68035fc2427850317fa141e63d68fa9cabaa152b4b02bfaff6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ef3d1be8d586c561fcad6e6e77e97955210621c0d0c1cb92c7321586de1a4cd"
    sha256 cellar: :any_skip_relocation, ventura:        "bf308ef20d5d8c84a42dc3e71ed71b6de7000e527d632ea3402e9c16225a5014"
    sha256 cellar: :any_skip_relocation, monterey:       "609f93aafa5b92687ad2838a4f6856150e270c6507de81e73adde621fda293dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb8a690fc77ba0067206fd631474515c97ea74719c18e30bfa441b9463849bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449e97d3c58d616d1c9eb1b632e7972b68cd802a1180a0c8b00e48a80f18a155"
  end

  depends_on "go" => :build
  depends_on "truffle" => :test
  depends_on "crytic-compile"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"medusa", "completion", shells: [:bash, :zsh])
  end

  test do
    system "truffle", "init"

    # medusa does not appear to work with 'shanghai' EVM targets yet, which became the
    # default in solc 0.8.20 / truffle 5.9.1
    # Use an explicit 'paris' EVM target meanwhile, which was the previous default
    inreplace "truffle-config.js", %r{//\s*evmVersion:.*$}, "evmVersion: 'paris'"

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

    fuzz_output = shell_output("#{bin}/medusa fuzz --target #{testpath} --assertion-mode --test-limit 100")
    assert_match(/PASSED.*assert_true/, fuzz_output)
    assert_match(/FAILED.*assert_false/, fuzz_output)
  end
end
