class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/62/6d/d671e27077c7d2721266180757c507e68f46403728c6e87eac1b4309c372/pylint-2.15.6.tar.gz"
  sha256 "25b13ddcf5af7d112cf96935e21806c1da60e676f952efb650130f2a4483421c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d0f99d145c77c277a4aa363d181418b7a376e609eb18d6cbf24bc26e8d12a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52942760ef2e88fdb0b0e7ec745c917a973f45a413e21b48d7e486e7b160cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dcc40772f2c77533096b47f70505974a9d28ce38a6f1ed574d113c50617732c"
    sha256 cellar: :any_skip_relocation, ventura:        "803f016370768bf83ad5effd8e7ec2869ac035952412d1be69e079a13e4100c9"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5b16e1ee22af68485725e648a3ec161518c5bb31fcd0a63328c6f69e849bd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e6512e4f75911ba0a3338554e025d2b59914a94e4d6691170064b4e520599f3"
    sha256 cellar: :any_skip_relocation, catalina:       "5bebd2800a56659ef238cb26119e4ccfcead83c869207ca12e926fe1bea0cea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cebc00937a131e30027545f6a8ea90ef2b48fc46f221ccdaf6d1b2be692e576"
  end

  depends_on "isort"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/be/61/5a97efa0622b3413e3d01d6bc6b019a87bcc23058c378dbd24b8c2474860/astroid-2.12.12.tar.gz"
    sha256 "1c00a14f5a3ed0339d38d2e2e5b74ea2591df5861c0936bb292b84ccf3a78d83"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/74/37/591f89e8a09ae4574391bdf8a5eecd34a3dbe545917333e625c9de9a66b0/lazy-object-proxy-1.8.0.tar.gz"
    sha256 "c219a00245af0f6fa4e95901ed28044544f50152840c5b6a3e7b2568db34d156"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/5f/dda8451435f17ed8043eab5ffe04e47d703debe8fe845eb074f42260e50a/platformdirs-2.5.4.tar.gz"
    sha256 "1006647646d80f16130f052404c6b901e80ee4ed6bef6792e1f238a8969106f7"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
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
