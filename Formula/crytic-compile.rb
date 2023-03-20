class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/36/59/518760d90ab6ccf06f1954325b2e62274ccb82bbfaf3e40d341558789f44/crytic-compile-0.3.0.tar.gz"
  sha256 "4f672921124931137abfb48359bba66d85e8c71cda9ea780380f62bbc7a20e7d"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "909390b947b5372ffe918befa4fe525107182876a00d93aa9f7d7d2ac1195832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "505aa0dfac049b4822ee3aee14f02364c17adf643923d75d49b511b4baef5ef9"
    sha256 cellar: :any_skip_relocation, ventura:        "aba2b82820989d0e833be91e5b7c199880fbb4d0f04f45aafc3daa537e2f63b0"
    sha256 cellar: :any_skip_relocation, monterey:       "eef1a7b9d115519d0aa7cb79ebc42b6db3e2bb68f1bf593d5b18c4e2b089baa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dfaabbf29da663acd82b8b072d96968e08bfd8a872b18dc12b8d1699e1af9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "052978c5e93d0b9ac82d09fd3955ca2d9d1f7d9fe5cdc241085284badf3684c2"
  end

  depends_on "python@3.11"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/0d/66/5e4a14e91ffeac819e6888037771286bc1b86869f25d74d60bc4a61d2c1e/pycryptodome-3.16.0.tar.gz"
    sha256 "0e45d2d852a66ecfb904f090c3f87dc0dfb89a499570abad8590f10d9cffb350"
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
