class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/0b/3f/915ca0f0431b68a5e4f155fef4a8b40a472c6107eb4ddfba4bcfa8428257/pylint-2.7.1.tar.gz"
  sha256 "81ce108f6342421169ea039ff1f528208c99d2e5a9c4ca95cfc5291be6dfd982"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55eaf1faf8fd5ac79c307456242c35d16fa6c50553d6841207de3de249e31fc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6f2a6b9f635cbd2b3ab6fb48391486a940be2b24fb27a81b365294e5c84634a"
    sha256 cellar: :any_skip_relocation, catalina:      "95905f9440675e405d0729934a30df56f9bc2439c9318affbb4ea5ff72b3d98c"
    sha256 cellar: :any_skip_relocation, mojave:        "68f462e1aca2b2c5c1087f765d68764fd97da82157f3d711ef528b899fa6044b"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/18/00/753b485627d9cd642516c195db63dcc0c87c36b8c682125c000b7f611b09/astroid-2.5.tar.gz"
    sha256 "b31c92f545517dcc452f284bc9c044050862fbe6d93d2b3de4a215a6b384bf0d"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/a2/f7/f50fc9555dc0fe2dc1e7f69d93f71961d052857c296cad0fb6d275b20008/isort-5.7.0.tar.gz"
    sha256 "c729845434366216d320e936b8ad6f9d681aab72dc7cbc2d51bedc3582f3ad1e"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/95/b7/8823606ab25245effb6907fd7699f2234ae0bbd39e0c7b10b84def966f45/lazy-object-proxy-1.5.2.tar.gz"
    sha256 "5944a9b95e97de1980c65f03b79b356f30a43de48682b8bdd90aa5089f0ec1f4"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
