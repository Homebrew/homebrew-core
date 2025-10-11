class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/96/70/9c3b8bc5ef6620efd46fd3b075439a8068637f4b4176a59d81e9d2373685/johnnydep-1.20.6.tar.gz"
  sha256 "751a1d74d81992c45b31d4094ef42ec4287b0628a443d02a21523f1175b82e2f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dfb64922d55bb3c439ad6b4530ba5529033b1398127243c196eceaf6eeaebaf7"
    sha256 cellar: :any,                 arm64_sequoia: "f8a1c7e9a1e998a436515dee6d884184825809cb8b28e0e3ada0535741623cd2"
    sha256 cellar: :any,                 arm64_sonoma:  "0129fb3e931ed3daf34bc8a3f8ee2f8c977f5bca3715e2217bcebf4b892cee40"
    sha256 cellar: :any,                 arm64_ventura: "e2db6a6d86bd35707bcb6c59374ec6c2e2028762608f277765c5c231ef7968f5"
    sha256 cellar: :any,                 sonoma:        "91989a32152c46c1679308e47df4f09324d553c367bb6a8831e10c28d6219d9e"
    sha256 cellar: :any,                 ventura:       "16c7f002b8f7e9b8c62f364bd7eef09fd86d1b97d71527eae9fd3ceba81a7840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf004439db78ed17e882aabbaea88c03f86de37985d2cc31673fcffcee291e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e599029b28fd894192f6cc5fc57df31f6e1b3bf3d2ceae69aa8763c3037a352"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/61/e4fad8155db4a04bfb4734c7c8ff0882f078f24294d42798b3568eb63bff/cachetools-6.2.0.tar.gz"
    sha256 "38b328c0889450f05f5e120f56ab68c8abaf424e1275522b138ffc93253f7e32"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/79/b9/6e672db4fec07349e7a8a8172c1a6ae235c58679ca29c3f86a61b5e59ff3/structlog-25.4.0.tar.gz"
    sha256 "186cd1b0a8ae762e29417095664adf1d6a31702160a46dacb7796ea82f7409e4"
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
