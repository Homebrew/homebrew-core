class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/7f/97/d8fe6561bb84abef6e1ec0973059c6d6fff161ccd8dd804bef5274750e4d/pdm-0.10.2.tar.gz"
  sha256 "46ec6c6c8bcf18961ccd81c3082221a9de075046ed9f23f68fdc41c0eedb12b6"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e69a7840a3256d319d6d81548abe354db8f246de13a4ea236c5b4103c3af5632" => :catalina
    sha256 "971c1f5f7edcf3991b48875946333c08912e0bf09fa1a2cfa1a4bc6734f1cb7a" => :mojave
    sha256 "f89a9aba124565d58255e5a1c107c7bd9a1b552057890d382e9c29ea0e5feb99" => :high_sierra
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/81/d0/641b698d05f0eaea4df4f9cebaff573d7a5276228ef6b7541240fe02f3ad/attrs-20.2.0.tar.gz"
    sha256 "26b54ddbbb9ee1d34d5d3668dd37d6cf74990ab23c828c2888dccdceee395594"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "halo" do
    url "https://files.pythonhosted.org/packages/ae/47/80742a791ea21ceb9e6e1355e341b3c9223d7710df5874fe6faba9734484/halo-0.0.30.tar.gz"
    sha256 "ad1fb4d7e29fe846d323bf4a8bf9e65fddcb24c10258c13e964cab13278f9568"
  end

  resource "log-symbols" do
    url "https://files.pythonhosted.org/packages/45/87/e86645d758a4401c8c81914b6a88470634d1785c9ad09823fa4a1bd89250/log_symbols-0.0.14.tar.gz"
    sha256 "cf0bbc6fe1a8e53f0d174a716bc625c4f87043cc21eb55dd8a740cfe22680556"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/f8/ff/52a5536a593cbca888c8725a989c33efc73a2e850a6f30003a07e7c816bb/pdm-pep517-0.2.1.tar.gz"
    sha256 "c8fd5d86cae9d304363950590e97793128c5bbc2a5c009054d60d645e53017cb"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/31/65/399b2e85e1ee5e34d797643b1d1ce3ec3f2b612e0680d6b7b455c24cb7a7/pep517-0.9.1.tar.gz"
    sha256 "aeb78601f2d1aa461960b43add204cc7955667687fbcf9cdb5170f00556f117f"
  end

  resource "pip-shims" do
    url "https://files.pythonhosted.org/packages/d7/01/7a797f03c3a61b09edd51b54e8d3cc0c70159ba76a1fcd57654baffcd5bd/pip_shims-0.5.3.tar.gz"
    sha256 "05b00ade9d1e686a98bb656dd9b0608a933897283dc21913fad6ea5409ff7e91"
  end

  resource "pycomplete" do
    url "https://files.pythonhosted.org/packages/42/3d/d125a7a64ec1e9573025bc080de566fc7aca209f2956091c4bdc3939a4e7/pycomplete-0.3.1.tar.gz"
    sha256 "7f7532f7e0950e4e8c8017f89acb3f3e645cce1f164020ab9792fd5100c11211"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-cfonts" do
    url "https://files.pythonhosted.org/packages/9d/a8/80c4752ef182d83e9aa05254fbdabb0ae2170ccdd5890673ebfe409281c7/python-cfonts-1.3.1.tar.gz"
    sha256 "50d9e3153034d7e27e74c3c62009275ff0fe0d54d8cd3d283e7f014a9d830d43"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/79/08/c08e07764115bbb386e9b1761ac687d7c952eb4127a99f37aeee72030aa0/pythonfinder-1.2.5.tar.gz"
    sha256 "481fba9cb7ffa43fe5b5b5c4c5cbcec565a79762e24daff65043158a93fc1986"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/86/f1/d5cc77eae2b76aeb3c461ff42abb8506ac3e6621fcc97b054d3b09eb4291/resolvelib-0.5.2.tar.gz"
    sha256 "95146a916aa0551603fc524bedf230e3f312bd57ce02b5b9233e4fc44057a7fa"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "spinners" do
    url "https://files.pythonhosted.org/packages/d3/91/bb331f0a43e04d950a710f402a0986a54147a35818df0e1658551c8d12e1/spinners-0.0.24.tar.gz"
    sha256 "1eb6aeb4781d72ab42ed8a01dcf20f3002bf50740d7154d12fb8c9769bf9e27f"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/64/e0/6c8c96024d118cb029a97752e9a6d70bd06e4fd4c8b00fd9446ad6178f1d/tomlkit-0.7.0.tar.gz"
    sha256 "ac57f29693fab3e309ea789252fcce3061e19110085aa31af5446ca749325618"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [tool.pdm]
      python_requires = ">=3.9"

      [tool.pdm.dependencies]

      [tool.pdm.dev-dependencies]
    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "[tool.pdm.dependencies]\nrequests = \"==2.24.0\"", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
