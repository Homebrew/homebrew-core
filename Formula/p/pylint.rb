class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/24/4f/5ca8d654d69006b3a5d52332e56359448b5c5ce242574a8ff26cb260ac3d/pylint-3.0.3.tar.gz"
  sha256 "58c2398b0301e049609a8429789ec6edf3aabe9b6c5fec916acd18639c16de8b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0394d9ab0c13809fc0bfa343b2a520d01decfd3630241b35ee0e112984c0111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f62cfef4d1142f681f0229d259586aebf0c5e1eec84c24fcd5579f1812c637e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849085afbb3407fecc01f1d53fd311effde896350be3ca79dbe958789ac04f58"
    sha256 cellar: :any_skip_relocation, sonoma:         "1057ec4e9964451876978b2e013c638a890125ead5544ddef833ee9a4c257271"
    sha256 cellar: :any_skip_relocation, ventura:        "ebfc0873d65e3bc5923c9f586ba5aa4654677a0a64252cb3751c1820984179b8"
    sha256 cellar: :any_skip_relocation, monterey:       "a1821bb979a1ac217fae0d212c9fd691ebd1e8b41723351a58a73e17603d495f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3108b464d2b56a551965282655e8a1e730022b23be34ed675c54309e9754ff2d"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/69/53/07229db171855e410bf40a996f1d49cc35222e18a1c95cd566e69bb9e0e5/astroid-3.0.1.tar.gz"
    sha256 "86b0bb7d7da0be1a7c4aedb7974e391b32d4ed89e33de6ed6902b4b15c97577e"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
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
