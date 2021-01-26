class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/c2/86/1780344215357113758904bde0c95afd72c3b24ec275840af1cac70baf24/pdm-1.2.0.tar.gz"
  sha256 "33ec1e28bc789b96bbdb15090676f1032659842972d724f183a045c10bb25259"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a23d54393e63d1655cea46ee34a536f0029709c3bebc337d4297bca0af4d43a" => :big_sur
    sha256 "153a16242ce3623660a3e5755ab6836bf6c514c84cb032a345b66dda4272983c" => :arm64_big_sur
    sha256 "77c38040b13a745dca4b6649bd7c5e0429bbac1facb2f1709fb338d99d274ca4" => :catalina
    sha256 "e3ae77402a8e6ed461704875c48acef5a3bc7c86dc704dc6a1f54625d0ccd998" => :mojave
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
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

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/93/aa/84c06467f269a36582cf0212d2d39bd6300f6e0cbce49508af634c126d2e/keyring-22.0.0.tar.gz"
    sha256 "0bd9124892bdafd8db3c2ba22498dc6cca19b2b19fbcb32464f556889285241d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/9a/0a/f7f580befcf533968f7713e77d3b5c974cff1020c1a6671952424e18a632/pdm-pep517-0.5.2.tar.gz"
    sha256 "1256a369e5ee372368f03054e5f6c4d981a5b6f7a5c3fba442491b222dd1ef5c"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/31/65/399b2e85e1ee5e34d797643b1d1ce3ec3f2b612e0680d6b7b455c24cb7a7/pep517-0.9.1.tar.gz"
    sha256 "aeb78601f2d1aa461960b43add204cc7955667687fbcf9cdb5170f00556f117f"
  end

  resource "pycomplete" do
    url "https://files.pythonhosted.org/packages/28/ab/e08452acd7775aff9afd981ad08955dd25243f9411cf23c69a17724d5731/pycomplete-0.3.2.tar.gz"
    sha256 "671bfba70b6f2eecedad6b6daabac2aa3f1573cd790cc56ccd48b8067f584391"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-cfonts" do
    url "https://files.pythonhosted.org/packages/e7/ec/541df4649a6fbea6e68bba431df26cc17eb6c135d80cb528a084ae6942ae/python-cfonts-1.4.0.tar.gz"
    sha256 "5042bf039d2937e30511a9c675e8316de9eaff1d034db1b63789702f74266372"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/53/04/1a8126516c8febfeb2015844edee977c9b783bdff9b3bcd89b1cc2e1f372/python-dotenv-0.15.0.tar.gz"
    sha256 "587825ed60b1711daea4832cf37524dfd404325b7db5e25ebe88c495c9f807a0"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/79/08/c08e07764115bbb386e9b1761ac687d7c952eb4127a99f37aeee72030aa0/pythonfinder-1.2.5.tar.gz"
    sha256 "481fba9cb7ffa43fe5b5b5c4c5cbcec565a79762e24daff65043158a93fc1986"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/8f/7f/b8b2c7e8b2030710b6ef2d14b2201272dfe437d6c37cec29c60f38d3139d/resolvelib-0.5.4.tar.gz"
    sha256 "9b9b80d5c60e4c2a8b7fbf0712c3449dc01d74e215632e5199850c9eca687628"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/4b/f0/39516ebeaca978d6607609a283b15e7637622faffc5f01ecf78a49b24cd5/shellingham-1.3.2.tar.gz"
    sha256 "576c1982bea0ba82fb46c36feb951319d7f42214a82634233f58b40d858a751e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/64/e0/6c8c96024d118cb029a97752e9a6d70bd06e4fd4c8b00fd9446ad6178f1d/tomlkit-0.7.0.tar.gz"
    sha256 "ac57f29693fab3e309ea789252fcce3061e19110085aa31af5446ca749325618"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
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
      name = "testproj"
      python_requires = ">=3.9"

      [tool.pdm.dependencies]

      [tool.pdm.dev-dependencies]
    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
