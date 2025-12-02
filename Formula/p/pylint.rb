class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/5a/d2/b081da1a8930d00e3fc06352a1d449aaf815d4982319fab5d8cdb2e9ab35/pylint-4.0.4.tar.gz"
  sha256 "d9b71674e19b1c36d79265b5887bf8e55278cbe236c9e95d22dc82cf044fdbd2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e412985eb67330cb013068787d1f85f3d5b639cd69a4919ec6fb32a1109ae524"
  end

  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/b7/22/97df040e15d964e592d3a180598ace67e91b7c559d8298bdb3c949dc6e42/astroid-4.0.2.tar.gz"
    sha256 "ac8fb7ca1c08eb9afec91ccc23edbd8ac73bb22cbdd7da1d488d9fb8d6579070"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/12/80/630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042/dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/63/53/4f3c058e3bace40282876f9b553343376ee687f3c35a525dc79dbd450f88/isort-7.0.0.tar.gz"
    sha256 "5513527951aadb3ac4292a41a16cbc50dd1642432f5e8c20057d414bdafb4187"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
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
