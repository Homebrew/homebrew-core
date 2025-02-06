class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/ab/b9/50be49afc91469f832c4bf12318ab4abe56ee9aa3700a89aad5359ad195f/pylint-3.3.4.tar.gz"
  sha256 "74ae7a38b177e69a9b525d0794bd8183820bfa7eb68cc1bee6e8ed22a42be4ce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f629c2828d1f81dcd22b6283278a84046ca813f7fb3696092ab0b6cf4197d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f629c2828d1f81dcd22b6283278a84046ca813f7fb3696092ab0b6cf4197d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83f629c2828d1f81dcd22b6283278a84046ca813f7fb3696092ab0b6cf4197d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfa14a1a948badfd1f28a29a1d3db38d5630d509a522cfd4450e0c9d3b1d0f23"
    sha256 cellar: :any_skip_relocation, ventura:       "cfa14a1a948badfd1f28a29a1d3db38d5630d509a522cfd4450e0c9d3b1d0f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0312b2f2e46f7fb1b6429c132dde15c4e06c15ed9ba2db3e65d0bff079266b7f"
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
    url "https://files.pythonhosted.org/packages/1c/28/b382d1656ac0ee4cef4bf579b13f9c6c813bff8a5cb5996669592c8c75fa/isort-6.0.0.tar.gz"
    sha256 "75d9d8a1438a9432a7d7b54f2d3b45cad9a4a0fdba43617d9873379704a8bdf1"
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
