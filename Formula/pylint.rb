class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/5c/09/4948cd0ad3ef8ab707bab1169bc73672bda3ede1c92e528b02b940be67e8/pylint-2.7.2.tar.gz"
  sha256 "0e21d3b80b96740909d77206d741aa3ce0b06b41be375d92e1f3244a274c1f8a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9ad660f542293a84602d0342271c80d84de4897e3ea65b2c0369cb904f9e66e"
    sha256 cellar: :any_skip_relocation, big_sur:       "51e50930614ca9fb6881bbfaa2b6e074be2a02aa03b244fe506f400c47526dff"
    sha256 cellar: :any_skip_relocation, catalina:      "26f0378f5d293841df30ba39cdd2289465459017c5c77cb6662e2764d80dbc94"
    sha256 cellar: :any_skip_relocation, mojave:        "4742fca3c1acb9e40eee01eda416832f07a2e5dc8a70b04b3be8fb969ec387c0"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/44/47/fe9dfab6f91682d7bcacf8ca813b3084b48f1deda4ac8ee56e49d63b928e/astroid-2.5.1.tar.gz"
    sha256 "cfc35498ee64017be059ceffab0a25bedf7548ab76f2bea691c5565896e7128d"
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
