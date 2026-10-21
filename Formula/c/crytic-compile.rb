class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/d3/c1/ba7f089fbf73cef1f1684d8fb5ec7c47d6f81870ca3e21b32aed88196774/crytic_compile-0.4.2.tar.gz"
  sha256 "161325e40785d8e42cdd8846b98d4f82c291ca5bcd07b5feae1a84d5a18c59fb"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3836d8778a1c41c75032daf47a92be3f1097f52436e45be801b5e5d6363832d0"
    sha256 cellar: :any, arm64_tahoe:       "8bc2b0b9b77d37c7750a20691915750cd8100f0c8e332829808170f92df12865"
    sha256 cellar: :any, arm64_sequoia:     "b2a04f96745ee13d89a72f8d781b2d08b41654554322fe9eb82290243a6042fe"
    sha256 cellar: :any, arm64_linux:       "dc331d689fa177b75685657a248151be09ee7f227695572261840a6cd1e8c93e"
    sha256 cellar: :any, x86_64_linux:      "0be12845fb4350b453257bfaabb3e6a71337fe8b53a0aceb1926ebb05daedcd1"
  end

  depends_on "rust" => :build # for `cbor2`
  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/c6/14/b02446bacfe44351b1689c04937ade007588f44570431880a6937e525e6c/cbor2-6.1.4.tar.gz"
    sha256 "01ecc79a28f33d17331943ce508fc1e21f4b06553c73f874f4c77120d72b2ef9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
    sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "testdata", :test do
    url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
    sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_path_exists testpath/"export/combined_solc.json"
  end
end
