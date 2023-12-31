class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/3a/9c/e100d2dbc90471010716e56766ef6608717c44d7278eea3dacb5bb48276a/crytic-compile-0.3.5.tar.gz"
  sha256 "f9b2bf3dc8c99fbc58c4ae6f82b3e8e378f56e107e37fd8786a36567dd68fa6e"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bbc9a7933f163dc36195299a9b6cbba265f7f3a30e8fb04774550abe921b07d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddea1230595d14484cc120b51099d904d46ac2439531b3da655dd4dd613abfb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef090f529d4ebfbd9196dd3cbcafaea07468b3b572be67f4aa4b6c9ecbec43f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a18f19780b9da39b1a2a81bc06fa2d4822e2072ab8d192e50de947bf5107ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f2fc9d8bc6c5eaa1c2428ea334ed2f68b603633d755c8785d3d3b6bbd88bec"
    sha256 cellar: :any_skip_relocation, monterey:       "a61e6190a45a619f4e9293854061c83c93ac1c8bc888b2014fb633c6616cb7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e554ce1235c086e6f15fc183885f765e6c7a1766caabfcf0f12e216873ea78"
  end

  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.12")
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
