class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/61/22/814213bc9a757f664a30c718ff2b238c3835499a04c229df764eb1aefd69/pdm-1.14.1.tar.gz"
  sha256 "170b3c1a9541bb53f91fff7b25c54afae796464ccb58caa8a0b9ff37646120dd"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "363af46d648ae6b3859da37a74d040a7d5a5fcf425241d73d6d0cdcd1b6cc0bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e3575a673fcd09536d372e9f743038837c9a959c5ba4ffed68a0c6089f896bc"
    sha256 cellar: :any_skip_relocation, monterey:       "58de9c839350a0d17890176076c1c5789243422f23246f5e7ed4da3d781e27bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7fb39fad504e03bbb10f3e4ae1dd1afc8fe84b07d401ee8946718bb8518391c"
    sha256 cellar: :any_skip_relocation, catalina:       "a59e7bc0c41ac431138010b6a99fb7cdcdd4b60d5c1a1a7b472f5c76b240fee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da0c5a6ed8b6626334b99c3c3f587a3a1a14a28ca1066d59b73b0c9013e8357"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
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
    url "https://files.pythonhosted.org/packages/cd/29/5ccfe04da3d1c138e464a05244640d83f88881f99f7733391b7944aed994/pdm-pep517-0.12.3.tar.gz"
    sha256 "117bfb1619b86beb34fe009b8d41acacf790d1fc5240ccc11f6cada151d46887"
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
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
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
    url "https://files.pythonhosted.org/packages/60/cd/21a4dd7545350968e544f785e6be4273e6b58cc40a1ab1010d3ce573bc5a/tomlkit-0.10.1.tar.gz"
    sha256 "3c517894eadef53e9072d343d37e4427b8f0b6200a70b7c9a19b2ebd1f53b951"
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
