class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/24/5c/2f6971d158b8103b9e0271bab7d6146886b73b623979e60f89099e2cad68/pdm-1.15.2.tar.gz"
  sha256 "a5c750da9863a2c1c016dbeefa5392de4abf3bdb63b546184ae0c0d559f460e0"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add0dfeb731c066670da91f337fe4aaaa753ccb5125fff0115f0b0d4a018f73d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4fd73589f0a4e6f26fb258e3223d54d2c567c3df1a79a65e98bc423c2edd733"
    sha256 cellar: :any_skip_relocation, monterey:       "783997188f8aa6aecf2dad8ae2f40fb79408fc3a7593c43c13257455a00b097a"
    sha256 cellar: :any_skip_relocation, big_sur:        "daaa9d7efc696c537721c3b29f147efb6ed2a691cfa56c2144cb9ac6021d1a0f"
    sha256 cellar: :any_skip_relocation, catalina:       "2bbf83c29cf8343509c91e781c96f311d2c91e02e93594afba5591574164fabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95e1dc0bf8a323cd0fb9e692a75b3fbdf10c82805ced1c570f29b78eca261ae"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/a6/10/2235c5e4f64f70c05b60d5b7c3a2139e5effcdeb7831e980464e93f03397/findpython-0.1.6.tar.gz"
    sha256 "9fd6185cdcb96baa7109308447efb493b2c7f1a8f569e128af14d726b2a69e18"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/74/b7/9187323cd732840f1cddd6a9f05961406636b50c799eef37c920b63110c0/installer-0.5.1.tar.gz"
    sha256 "f970995ec2bb815e2fdaf7977b26b2091e1e386f0f42eafd5ac811953dc5d445"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/b9/7d/99f2f844ae1a3bfd6f4bfac3a523fad805163dcddebf6bf232cb93cca972/pdm-pep517-0.12.5.tar.gz"
    sha256 "cfd15e5498579186bdc0a1a7b6eea9f983e7c3a7dd1a2a7b0ad22d05d6dc5099"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0a/65/6e656d49c679136edfba25f25791f45ffe1ea4ae2ec1c59fe9c35e061cd1/pep517-0.12.0.tar.gz"
    sha256 "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/02/ee/43e1c862a3e7259a1f264958eaea144f0a2fac9f175c1659c674c34ea506/python-dotenv-0.20.0.tar.gz"
    sha256 "b7e3b04a59693c42c36f9ab1cc2acc46fa5df8c78e178fc33a8d4cd05c8d498f"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/24/24/e50be8344fc6e9c9ae55bfcb136b33ad562776d822736da3d1ec0278b18b/tomlkit-0.11.0.tar.gz"
    sha256 "71ceb10c0eefd8b8f11fe34e8a51ad07812cb1dc3de23247425fbc9ddc47b9dd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-pep517>=0.12.0"]
      build-backend = "pdm.pep517.api"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
