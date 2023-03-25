class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/e3/0f/f76d9bc9118d3d330d4d21fdf10ca1c58653aece583c05ae0c9ec4d0dc6a/crytic-compile-0.3.1.tar.gz"
  sha256 "2f0030315b297d1852353b03ace8a484fb0415e07b16ff6172173fbb51313590"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc3212149488e40aadecc0c5d069d3ef8cbcfbcc2e9094ef2d717e1a9b3f6af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e4afc309ee1ea55eac6040662721681af43eba8220348373f7ef55c2fd984d"
    sha256 cellar: :any_skip_relocation, ventura:        "9529b1a4b634d1b9c4edecf8ad255a34c7b2e3a278bfb1659b5fd1e2e4f726f6"
    sha256 cellar: :any_skip_relocation, monterey:       "06bcb5238e746e4852d0304ce12b0be8f2bd37a97a10ef62c31da3a33cf30518"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2742aad5f0095f36e6f16d6d085abf67521d1fdafb3b46f1800937bbd8bca06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c927e6a01a17bac0f7443261f164993edf7e90bcfeeed04da56eb37ce042dd"
  end

  depends_on "python@3.11"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.11")
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
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
