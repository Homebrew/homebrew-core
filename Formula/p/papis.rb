class Papis < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line document and bibliography manager"
  homepage "https://papis.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/70/22/365efb048e5a99a71d912acf95fd73b0a974a8df20487683817bf6ed44e6/papis-0.15.0.tar.gz"
  sha256 "9d0e319a4e04388bc1f705c272b607aaf2b678e33530bff64b1a58bc1364b788"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/papis/papis.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c477a726cb7d450419e6b41dccb23b54c7358928fb0c70de5a3fe84525383a2"
    sha256 cellar: :any, arm64_sequoia: "c53ad178c59bb58b9585467285d56d7f5489832f754e08be7b103411b38a2646"
    sha256 cellar: :any, arm64_sonoma:  "c01215da6465adb1ce01ab17f54732c8d5f81831eb10e077a65a304833b6f48a"
    sha256 cellar: :any, sonoma:        "3d422f8d97ed276f9ed4b76832c785edfa39ce09f28cdd0f129a10bc12e6c63b"
    sha256 cellar: :any, arm64_linux:   "c1db5202fb78d6295d7403a4269c8df179c6e9be2b1e09db0bea1a344d7d1dfb"
    sha256 cellar: :any, x86_64_linux:  "bf392cad4b27624db28df60bd556e4c053eff5bae410779bac8305d203811482"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
  end

  resource "arxiv" do
    url "https://files.pythonhosted.org/packages/fb/48/88c8e9c42712760ca9e74e52f6c4a388ee9e9939e341bfd8da295a9d1b17/arxiv-4.0.0.tar.gz"
    sha256 "1d30a1dba5054e0df9b1d63f8e190b58e6a59d0c2f4ccec344ce1de5bafe546d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bibtexparser" do
    url "https://files.pythonhosted.org/packages/44/1c/577d3ce406e88f370e80a6ebf76ae52a2866521e0b585e8ec612759894f1/bibtexparser-1.4.4.tar.gz"
    sha256 "093b6c824f7a71d3a748867c4057b71f77c55b8dbc07efc993b781771520d8fb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dominate" do
    url "https://files.pythonhosted.org/packages/fb/f3/1c8088ff19a0fcd9c3234802a0ee47006ea64bd8852f1019194f0e3583ff/dominate-2.9.1.tar.gz"
    sha256 "558284687d9b8aae1904e3d6051ad132dd4a8c0cf551b37ea4e7e42a31d19dc4"
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
    url "https://files.pythonhosted.org/packages/df/d6/c50bc0d3cd899145cdb0ce38641ae11bfbeaab6123c6e7e78f482570afb8/habanero-2.9.2.tar.gz"
    sha256 "efcdfecec965c413e0f1ee9034fbe955d42e6b815b0784aa0c4a3df2cc272019"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/47/06/5c12df521b5322fb1114a83d46911b2fbcb8855ddb3a635f11c01a214af5/httpcore2-2.5.0.tar.gz"
    sha256 "88aa170137c17328d5ac44234f9fd10706466d5fb347f3edac4d39b91137b09d"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/d0/e2/b5dedc0cf35aa65de5f541ccd30d2bc1fd7f1d43c9ab09f8ed9a7342317b/httpx2-2.5.0.tar.gz"
    sha256 "e2df9cb4611021527ff8a675b1c320b610a2ec397acc8d6fe6e91df2d9b33c29"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "isbnlib" do
    url "https://files.pythonhosted.org/packages/9e/6d/55b9ee89fdfb3aacb92b975a60357c7aa547db358817e16be3b6f8f5d781/isbnlib-3.10.14.tar.gz"
    sha256 "96f90864c77b01f55fa11e5bfca9fd909501d9842f3bc710d4eab85195d90539"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
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
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ae/5f/57ff8b434839e70dab45601284ea413e947a63799891b7553e5960a793a8/tqdm-4.68.4.tar.gz"
    sha256 "19829c9673638f2a0b8617da4cdcb927e831cd88bcfcb6e78d42a4d1af131520"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
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
