class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/9d/bf/ab7f6c4a9fb3acbfc2c3ba57321e3e87e78a0386454a7c09caa0d628cedf/pylint-2.17.3.tar.gz"
  sha256 "761907349e699f8afdcd56c4fe02f3021ab5b3a0fc26d19a9bfdc66c7d0d5cd5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4d35a84b0f496dc3f55f903b238def4cd29fc28b05e1c6edba17513c32627da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e3fd3afcfee00fe07e028768df22ef21d6063855a383dbeb8792e868346bb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f243461587a55a7c6dcda5e623c0d681845133b846ae3f4621dce3ea4ef44fe5"
    sha256 cellar: :any_skip_relocation, ventura:        "250ccb718ae9144a69afc88eee0f638d5519fd82ddc4b89df8bfccb7d564d371"
    sha256 cellar: :any_skip_relocation, monterey:       "5044f23f940160fe86a6bf982fcb716e5e87aa6da34aae6077be6a695cb5bfde"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9fb46999b57b1f6b98486b9372587ba2b9c5ebbcad27736a0e7d2ab96a2e04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b77f691710d7ef07871a8d44be6e6d3b224532ea5898e97769b8b6573b1f98a"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/36/50/c2bde258f4b8021ee9075932ace925245a1ad9a816a0cab269f04f480c3b/astroid-2.15.4.tar.gz"
    sha256 "c81e1c7fbac615037744d067a9bb5f9aeb655edf59b63ee8b59585475d6f80d8"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
