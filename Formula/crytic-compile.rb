class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/b7/20/ab81713424c364486ffd943cfffc471266d85231121d3e5972c7bd4b218f/crytic-compile-0.2.4.tar.gz"
  sha256 "926742306c4d188b4fdbf07abcfeb7525a82c11da11185aa53d845f257a6bb9a"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f3db6a44d52bcf9d929ffdc931f71dc66d2532cf5f8faddac360d4d9c3ee72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ce689ba323933cb83a9021ad2d61c161b75fc2135a471f41bafd6854d4c905b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4cdbd3b81023846db9217d684cd474abf8c8b46bacc4ce2b5e864f06400b37"
    sha256 cellar: :any_skip_relocation, monterey:       "df88c39d13cb0122344467b66b8e7f034b1c37233f5dca5c780c47c17c5a0089"
    sha256 cellar: :any_skip_relocation, big_sur:        "80119719686ffd01fdb79c060630e1e9f423ffc943e3cfd88d31919cee6d659c"
    sha256 cellar: :any_skip_relocation, catalina:       "0f5a8668fd5ff1b5b52986ad58089604879cdd178ecfbc872a8efc7f5e9d24d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636660a2cbc68a7052b2291156b827c57b4e8ee629124691d1d3ba882931b942"
  end

  depends_on "python@3.10"
  depends_on "solc-select"

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function f() public pure returns (bool) {
          return false;
        }
      }
    EOS

    system "solc-select", "install", "0.8.0"
    with_env(SOLC_VERSION: "0.8.0") do
      system bin/"crytic-compile", testpath/"test.sol", "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
