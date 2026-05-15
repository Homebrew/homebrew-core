class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/f4/cb/669ed02fbfe17091998f52a7e3326ac276409117ea10a2c36b2a852a22f9/crytic_compile-0.3.11.tar.gz"
  sha256 "d4e2253d5d81ec3a75deb3ab9fc2c2d2db56e835001cf07f3703911d74b56716"
  license "AGPL-3.0-only"
  revision 5
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f56fc9eb50c840fccc00f9e6740a85cbf14a4071de1e3be48326b7dfb73dac39"
    sha256 cellar: :any,                 arm64_sequoia: "2b291d458e742868c9267d0d47c6e497bc0b5e83d0cdbc8e599eeb3c85f50708"
    sha256 cellar: :any,                 arm64_sonoma:  "d9cc9aa192a6a3bc60c7f9a8119d577e340b68dcc71247b280e41653471fe47d"
    sha256 cellar: :any,                 sonoma:        "084cb2f5727210fcb62e3090462dc3551716fc7dd233cafd1fccd7074cd97051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d19541fa8e4767f4f28250d0ab08c555a641afdfa2e9dd4c12246583317c0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "739fc74f54a4d21d3f868f06b21c985d87891faa3e60c792e522f6cdba3b4a10"
  end

  depends_on "rust" => :build # for `cbor2`
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/3e/fe/5d7f37d51ec21cccf9ae14a42a674907b8385779e639482f83c6eff1bcee/cbor2-6.0.1.tar.gz"
    sha256 "46a745c296ec336fe83fa7905b77b4faa243eb32bb84fab1cfdb0e4636d1985b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
    sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
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

    assert_path_exists testpath/"export/combined_solc.json"
  end
end
