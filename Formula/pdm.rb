class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/35/61/f7c37dd26c810ef14b1fba95935c8c2be4240f1643d0a9d81a98b95115c6/pdm-1.5.0.tar.gz"
  sha256 "6a9a16b10016b35c1900843906512fb549f2c1059a5789acaa9b23982b5f7e37"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca3b05d6a983741521508018d975ba6f2044c2e90de00ba06d9d9aa3ab4d4801"
    sha256 cellar: :any_skip_relocation, big_sur:       "29797efde025b789218f9947a9c268aeb1ca0aa8eff503a5f01aa84e7c2a96b3"
    sha256 cellar: :any_skip_relocation, catalina:      "7af70ae41430b850e3dccd983938f55bd6358e9f5facef51a70d3b55611ac9a2"
    sha256 cellar: :any_skip_relocation, mojave:        "0e8dcb5a15c44ce593b193a2625eff9ce48eb1992275661949f230a00eb68be0"
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
    url "https://files.pythonhosted.org/packages/9a/5a/5bee793e43f6499b7e28de7c0333f49752590826b08a456f3874f555f4f5/importlib_metadata-4.0.0.tar.gz"
    sha256 "2e881981c9748d7282b374b68e759c87745c25427b67ecf0cc67fb6637a1bff9"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b0/b5/b27458e1d2adf2a11c6e95c67ac63f828e96fe7e166132e5dacbe03e88c0/keyring-23.0.1.tar.gz"
    sha256 "045703609dd3fccfcdb27da201684278823b72af515aedec1a8515719a038cb8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/c1/95/1afb82a4c61ce5b7354280c66c01d7e76b192bf133c5fb811e7e639bcc42/pdm-pep517-0.7.0.tar.gz"
    sha256 "aeb25e17e1ddd4d06264946b84e0043db39cb2ab5f812b4cccca116511aeab81"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0f/4c/ac5dc83e7afa327ea9b018a15193a4f1cd8bcce85263a60c127fdcf8ffd3/pep517-0.10.0.tar.gz"
    sha256 "ac59f3f6b9726a49e15a649474539442cf76e0697e39df4869d25e68e880931b"
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
    url "https://files.pythonhosted.org/packages/27/ec/5ce6e87222af71a508ec6bbbe3923a9c6440b6a41e9618006c2b7e69a4a7/python-dotenv-0.17.0.tar.gz"
    sha256 "471b782da0af10da1a80341e8438fca5fadeba2881c54360d5fd8d03d03a4f4a"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/0d/fc/8ce27504a863ec89478f953ee7293ad62e33c3ca0bb659cfc0ca1b37ff3b/pythonfinder-1.2.6.tar.gz"
    sha256 "21ffb77b152ae14c5c7d9b1c98c6df0a1a34d4b3e050da39f561224e7664a5f4"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/af/91/9c0a7a26d77806184980411f38243acf2611f9ff5c91e8f94ea437688e3a/resolvelib-0.7.0.tar.gz"
    sha256 "8840a8bf49fd56cff51398ebfe090e5d6aeaf4c4102472bff006aca7db470868"
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
