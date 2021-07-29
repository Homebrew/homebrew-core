class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/47/18/d148ae88f254cbb9a8763beae34027bc603dc6f57b29c48f7cb3f2e28cde/pylint-2.9.6.tar.gz"
  sha256 "8b838c8983ee1904b2de66cce9d0b96649a91901350e956d78f289c3bc87b48e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5be039c7f4d8c63b32e94112c9065271883b78fd71686eddbc641286e6f24a66"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5164890e78e74a464c737e48efb04d99176c83f405991f66b230e8fe55ab697"
    sha256 cellar: :any_skip_relocation, catalina:      "e8ecce31c2fccb2c82b2d5aa95c29aa8302fa3f7ce79f3d0ffee450728d4d538"
    sha256 cellar: :any_skip_relocation, mojave:        "00c5db58dd64bc4580689a937e089ef8d8570f44981d2043ba444b2bb34feef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb3cc769259334f8e714aad57cdc5772749a67c67ee20a36264c19258bff7c8"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/89/e7/69f2b466eaf494f90f9aee9f802ab9305e2af1b9cd6aebdfdf36800706c8/astroid-2.6.5.tar.gz"
    sha256 "83e494b02d75d07d4e347b27c066fd791c0c74fc96c613d1ea3de0c82c48168f"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ac/2a/87e6a7d3c3953ddfb37c6da3fd951490425a60d2ab0be059b321d5788dc8/isort-5.9.2.tar.gz"
    sha256 "f65ce5bd4cbc6abdfbe29afc2f0245538ab358c14590912df638033f157d555e"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/bb/f5/646893a04dcf10d4acddb61c632fd53abb3e942e791317dcdd57f5800108/lazy-object-proxy-1.6.0.tar.gz"
    sha256 "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726"
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
