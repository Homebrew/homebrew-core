class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://github.com/crytic/crytic-compile/archive/refs/tags/0.2.3.tar.gz"
  sha256 "b41cc3ca6e43b70c2257dba5c1e794ca0881577f908acee9bc5bdfb132792e30"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3286e1e5fc19e0d5409b4cec48482acf9ad02c66d22589c47b3b8fc2b77aac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d73909104333de34e100bfae62541db0862e5c52ead3c7b61e2d206e3a5ef40"
    sha256 cellar: :any_skip_relocation, monterey:       "85dc542ae59d25f6325c20f777b02b6b6f641066ca1c1df858e8cf4701093a89"
    sha256 cellar: :any_skip_relocation, big_sur:        "198cb28968c7c0acbf8f22a96638dd3e58aa7e520590e793a09cce3099c97313"
    sha256 cellar: :any_skip_relocation, catalina:       "e8bc53bbfe70499d8457d5ec04143665f172954e2ddf37bec3ac79d0ed830f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a694fd55a787de5e26306ace11bc007a9c012bfe20a9b51c0cfd5c883277d0"
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
