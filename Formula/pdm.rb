class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/ed/22/a0c333dc2c61d2205e76cbc4ab010196fcfb6f5026323d56682238249513/pdm-1.4.1.tar.gz"
  sha256 "1f7d1a1787b0944ab26e6394be1d39c0326a82ea030232222b7c00b740897130"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d28b7f52071ae80a0bb406d4048fe1908f661672b966b9c805fef18e51990189"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ed74bc0431a5b8237cee333498a3aed207c8cc75b8a077f113653eeb39aca00"
    sha256 cellar: :any_skip_relocation, catalina:      "7c8dd75720167b728fcd3f39fb6f16893f8c1a5047e985f7f000d647ef13d5f8"
    sha256 cellar: :any_skip_relocation, mojave:        "05620a58c4dbff365976305ff8b329503c39a2c0c0c12e9d053f1be7dc2b7990"
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

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/48/18/08eaa583eb21602e86e32d534fa7f40159774566037e60a69822b10ef3ad/importlib_metadata-3.7.2.tar.gz"
    sha256 "18d5ff601069f98d5d605b6a4b50c18a34811d655c55548adc833e687289acde"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/e8/3e/4daf55c21dc38dfa39a5780fb1c9a15dbbe8d680a715b0c81c29be51662c/keyring-23.0.0.tar.gz"
    sha256 "237ff44888ba9b3918a7dcb55c8f1db909c95b6f071bfb46c6918f33f453a68a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/00/96/a3719b4631ebe6b536ee10f6fd87603771cf5593d9cae54bddf77d7eb2b2/pdm-pep517-0.5.7.tar.gz"
    sha256 "bd46b611b10d7213c3a3a04a0299cd66f31e1b87d386fc08f11b9ad545f3314e"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0f/4c/ac5dc83e7afa327ea9b018a15193a4f1cd8bcce85263a60c127fdcf8ffd3/pep517-0.10.0.tar.gz"
    sha256 "ac59f3f6b9726a49e15a649474539442cf76e0697e39df4869d25e68e880931b"
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
    url "https://files.pythonhosted.org/packages/52/ba/3860b1bfe6b08a727deddda52287282e10303d20f01321c3666f2e602c18/resolvelib-0.5.5.tar.gz"
    sha256 "123de56548c90df85137425a3f51eb93df89e2ba719aeb6a8023c032758be950"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
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

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/38/f9/4fa6df2753ded1bcc1ce2fdd8046f78bd240ff7647f5c9bcf547c0df77e3/zipp-3.4.1.tar.gz"
    sha256 "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76"
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
