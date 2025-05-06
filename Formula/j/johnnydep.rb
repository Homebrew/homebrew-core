class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/96/70/9c3b8bc5ef6620efd46fd3b075439a8068637f4b4176a59d81e9d2373685/johnnydep-1.20.6.tar.gz"
  sha256 "751a1d74d81992c45b31d4094ef42ec4287b0628a443d02a21523f1175b82e2f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f8a1c7e9a1e998a436515dee6d884184825809cb8b28e0e3ada0535741623cd2"
    sha256 cellar: :any,                 arm64_sonoma:  "0129fb3e931ed3daf34bc8a3f8ee2f8c977f5bca3715e2217bcebf4b892cee40"
    sha256 cellar: :any,                 arm64_ventura: "e2db6a6d86bd35707bcb6c59374ec6c2e2028762608f277765c5c231ef7968f5"
    sha256 cellar: :any,                 sonoma:        "91989a32152c46c1679308e47df4f09324d553c367bb6a8831e10c28d6219d9e"
    sha256 cellar: :any,                 ventura:       "16c7f002b8f7e9b8c62f364bd7eef09fd86d1b97d71527eae9fd3ceba81a7840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf004439db78ed17e882aabbaea88c03f86de37985d2cc31673fcffcee291e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e599029b28fd894192f6cc5fc57df31f6e1b3bf3d2ceae69aa8763c3037a352"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/78/b8/d3670aec25747e32d54cd5258102ae0d69b9c61c79e7aa326be61a570d0d/structlog-25.2.0.tar.gz"
    sha256 "d9f9776944207d1035b8b26072b9b140c63702fd7aa57c2f85d28ab701bd8e92"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "wimpy" do
    url "https://files.pythonhosted.org/packages/6e/bc/88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81/wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/johnnydep -v0 --output-format=pinned pip==25.0.1")
    assert_match "pip==25.0.1", output
  end
end
