class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/63/3a/13e90e29777e695d90f422cf4fadb81c999e4755a9089838561bd0590cac/pylint-3.3.1.tar.gz"
  sha256 "9f3dcc87b1203e612b78d91a896407787e708b3f189b5fa0b307712d49ff0c6e"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec3a55a6cc18eb434dce4f330941fbdf13802b0e787cb038f65721fe1f0c2f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec3a55a6cc18eb434dce4f330941fbdf13802b0e787cb038f65721fe1f0c2f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eec3a55a6cc18eb434dce4f330941fbdf13802b0e787cb038f65721fe1f0c2f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4cde6ff38065b0ec06078e191e584ce20c3e9fe98149db2f83741a7ccc0186"
    sha256 cellar: :any_skip_relocation, ventura:       "ed4cde6ff38065b0ec06078e191e584ce20c3e9fe98149db2f83741a7ccc0186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80854984bc349a8195986e02636c6721345b9eff7cf870108a3b22141b8d18d5"
  end

  depends_on "python@3.13"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/38/1e/326fb1d3d83a3bb77c9f9be29d31f2901e35acb94b0605c3f2e5085047f9/astroid-3.3.5.tar.gz"
    sha256 "5cfc40ae9f68311075d27ef68a4841bdc5cc7f6cf86671b49f00607d30188e2d"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/70/43/86fe3f9e130c4137b0f1b50784dd70a5087b911fe07fa81e53e0c4c47fea/dill-0.3.9.tar.gz"
    sha256 "81aa267dddf68cbfe8029c42ca9ec6a4ab3b22371d1c450abc54422577b4512c"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
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
