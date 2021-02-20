class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/f7/d4/c065f898e48e0d839525a2ede871f6f083ad322fb42c0ca0e7cf7ab7bb07/pylint-2.6.2.tar.gz"
  sha256 "718b74786ea7ed07aa0c58bf572154d4679f960d26e9641cc1de204a30b87fc9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "239c6846d9f665cdc7ed3c8ff5103013fc254240bcadb87258fdd51d504a33a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "284a5f5c2bc3c701eb546a30e7787e9e30ff81a962c7d111045469e70e3f063b"
    sha256 cellar: :any_skip_relocation, catalina:      "482e0e2485e9020c5d05a09fc647c83a12781cc361f52e9b225ed5ef1505877b"
    sha256 cellar: :any_skip_relocation, mojave:        "1213d2dc506b59841163cc78347362e60f19bfac76251bcb165ee735dc0594e9"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/ee/25/d3f01bc7e16641e0acb9a8c12decf1d5c2f04336c1f19ba69dc8e6927dff/astroid-2.4.2.tar.gz"
    sha256 "2f4078c2a41bf377eea06d71c9d2ba4eb8f6b1af2135bec27bbbb7d8f12bb703"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/a2/f7/f50fc9555dc0fe2dc1e7f69d93f71961d052857c296cad0fb6d275b20008/isort-5.7.0.tar.gz"
    sha256 "c729845434366216d320e936b8ad6f9d681aab72dc7cbc2d51bedc3582f3ad1e"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/07/3f/a3d687f83c7d44970f70ff0400677746c8860b11f0c08f6b4e07205f0cdc/lazy-object-proxy-1.4.3.tar.gz"
    sha256 "f3900e8a5de27447acbf900b4750b0ddfd7ec1ea7fbaf11dfa911141bc522af0"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
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
