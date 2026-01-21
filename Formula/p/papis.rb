class Papis < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line document and bibliography manager"
  homepage "https://papis.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/7a/d3/2b346625aa3803e47b9faa82b1a66a824e91c43cf45e5b228009060fb666/papis-0.14.1.tar.gz"
  sha256 "1970e549d8931d560b283bdc883a744f1634afbf23bad8eb244dfa967f66ba78"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/papis/papis.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61fc94ce9fb304110cb9c279887770da43c2143279b6d0a48af1c03e4333834c"
    sha256 cellar: :any,                 arm64_sequoia: "b925441445ec81a4e21372fcc3f3b7d7cea90f2005747faa25d1eab6d5a32a7f"
    sha256 cellar: :any,                 arm64_sonoma:  "548fb07c4995f7d65538a428a8f6411955dc85b5c8b7b4ed41be81b280261b5a"
    sha256 cellar: :any,                 sonoma:        "bf4cdd8fb703973dac0d27cfc3edcc0d6fb32f1da4316a6aae5b68a31a589718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fda5f0e2aab02e90cb70abc612038ef4d2fbe5ff80b352dde91785b208fec262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2939e6db35e9e4e2812c80acfb99fea757c6aee51cc100f58adeca977f7c1a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "arxiv" do
    url "https://files.pythonhosted.org/packages/8d/aa/dc1c6c633f63fce090e7c067af8c528a5e61218a61c266ff615d46cbde0a/arxiv-2.4.0.tar.gz"
    sha256 "cabe5470d031aa3f22d2744a7600391c62c3489653f0c62bec9019e62bb0554b"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "bibtexparser" do
    url "https://files.pythonhosted.org/packages/92/8d/e296c7af03757debd8fc80df2898cbed4fb69fc61ed2c9b4a1d42e923a9e/bibtexparser-1.4.3.tar.gz"
    sha256 "a9c7ded64bc137720e4df0b1b7f12734edc1361185f1c9097048ff7c35af2b8f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dominate" do
    url "https://files.pythonhosted.org/packages/fb/f3/1c8088ff19a0fcd9c3234802a0ee47006ea64bd8852f1019194f0e3583ff/dominate-2.9.1.tar.gz"
    sha256 "558284687d9b8aae1904e3d6051ad132dd4a8c0cf551b37ea4e7e42a31d19dc4"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/dc/79/db7edb5e77d6dfbc54d7d9df72828be4318275b2e580549ff45a962f6461/feedparser-6.0.12.tar.gz"
    sha256 "64f76ce90ae3e8ef5d1ede0f8d3b50ce26bcce71dd8ae5e82b1cd2d4a5f94228"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "habanero" do
    url "https://files.pythonhosted.org/packages/7e/79/e1463d0829f1b9d9a140ea78dda9461c13a8d9589797ab1ff5b7fffd133f/habanero-2.3.0.tar.gz"
    sha256 "871e5d088ef641b05514d44b004af512852b309bcd0d81f10545e58d54a654ab"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "isbnlib" do
    url "https://files.pythonhosted.org/packages/9e/6d/55b9ee89fdfb3aacb92b975a60357c7aa547db358817e16be3b6f8f5d781/isbnlib-3.10.14.tar.gz"
    sha256 "96f90864c77b01f55fa11e5bfca9fd909501d9842f3bc710d4eab85195d90539"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  resource "python-doi" do
    url "https://files.pythonhosted.org/packages/fd/03/b71a3b7f4deba34b60b2d65342facaf916c5dcb62e31494dc4356d153550/python-doi-0.2.0.tar.gz"
    sha256 "2e01e56fb319bd219ea8586baa43a1fc794dfe45a83156ac70242c4ce961fd9a"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "sgmllib3k" do
    url "https://files.pythonhosted.org/packages/9e/bd/3704a8c3e0942d711c1299ebf7b9091930adae6675d7c8f476a7ce48653c/sgmllib3k-1.0.0.tar.gz"
    sha256 "7868fb1c8bfa764c1ac563d3cf369c381d1325d36124933a726f29fcdaa812e9"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/89/23/adf3796d740536d63a6fbda113d07e60c734b6ed5d3058d1e47fc0495e47/soupsieve-2.8.1.tar.gz"
    sha256 "4cf733bc50fa805f5df4b8ef4740fc0e0fa6218cf3006269afd3f9d6d80fd350"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"papis", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papis --version")

    assert_match "No documents retrieved", shell_output("#{bin}/papis list 2>&1")
  end
end
