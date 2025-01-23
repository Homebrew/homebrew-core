class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/17/fd/e9a739afac274a39596bbe562e9d966db6f3917fdb2bd7322ffc56da0ba2/pylint-3.3.3.tar.gz"
  sha256 "07c607523b17e6d16e2ae0d7ef59602e332caa762af64203c24b41c27139f36a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88343a7685198c1ddc82e824a22341888a0d364b6087f914cf0c872a8907315d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88343a7685198c1ddc82e824a22341888a0d364b6087f914cf0c872a8907315d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88343a7685198c1ddc82e824a22341888a0d364b6087f914cf0c872a8907315d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c954f00547bf51012c4e1cb20b9dc463807796b07537cf4327bc70a32758f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a1c954f00547bf51012c4e1cb20b9dc463807796b07537cf4327bc70a32758f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6360a878e46375342130cb09df940bae586b6427d06c6ddeb43c2642f4682328"
  end

  depends_on "python@3.13"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/80/c5/5c83c48bbf547f3dd8b587529db7cf5a265a3368b33e85e76af8ff6061d3/astroid-3.3.8.tar.gz"
    sha256 "a88c7994f914a4ea8572fac479459f4955eeccc877be3f2d959a33273b0cf40b"
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
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
