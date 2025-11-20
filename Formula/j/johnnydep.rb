class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/96/70/9c3b8bc5ef6620efd46fd3b075439a8068637f4b4176a59d81e9d2373685/johnnydep-1.20.6.tar.gz"
  sha256 "751a1d74d81992c45b31d4094ef42ec4287b0628a443d02a21523f1175b82e2f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "6c203112106922fb1e46d8002128cd66734fb5adfa3d0d0a72e7f1186a6b7198"
    sha256 cellar: :any,                 arm64_sequoia: "8bec8ae2d8725c123a9cf211047d10efbf47a3e454a9d31cff1f862e8d06d995"
    sha256 cellar: :any,                 arm64_sonoma:  "f514171f90b831271b976c76a33a9ef71cfeeca5a6a761b053ec333bde0e5925"
    sha256 cellar: :any,                 sonoma:        "70a32a8773be96c92c27c938b6eba4fc20e8bef8799c34ec330ff635b407a692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e6ad48bf9f17579c0c21d2c397581bdd8e5669bab2b7795e39be831e80422d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1f6f72a599fa4b9edb63a6b36c62213ba36780489cc602d638d37c94f1edca"
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
