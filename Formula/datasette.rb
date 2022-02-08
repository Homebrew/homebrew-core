class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/26/b8/8e08fc3abed8fb9f88291b53b71b3b43d361800959219f3dab87c0fc8a3d/datasette-0.60.2.tar.gz"
  sha256 "167b25d3c02f3fbeb98ed1fafc6d5f77e3089c4a415f17a80ea148cbadb52f93"
  license "Apache-2.0"
  head "https://github.com/simonw/datasette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f2136a75bb51a6fabf9d84c80aefc4573b41cc4d754595fee49a8e125942ff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5defdd9e24d9ce687cf072767ed35fa5d1631e7a4af9f4b1c55a1cf9657324"
    sha256 cellar: :any_skip_relocation, monterey:       "f47c26cfa58e82af7389e8469903f2ccbdb245b0a3b9ed9d6bde502051a49d8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0cf6504cbd54e80438a050abaf8d7deedd082f0bc2be8ab634972a27094e342"
    sha256 cellar: :any_skip_relocation, catalina:       "b874407c9d92fd0054276e4b92b3ff6e2ded34a2752be1c8a18d34d311c2b7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4ad9b3f1a369c7e62289b7072dfa5638b3b988e7de29de3d9170fe27d9fa43"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/10/ca/c416cfacf6a47e1400dad56eab85aa86c92c6fbe58447d12035e434f0d5c/aiofiles-0.8.0.tar.gz"
    sha256 "8334f23235248a3b2e83b2c3a78a22674f39969b96397126cc93664d9a901e59"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/4f/d0/b957c0679a9bd0ed334e2e584102f077c3e703f83d099464c3d9569b7c8a/anyio-3.5.0.tar.gz"
    sha256 "a0aeffe2fb1fdf374a8e4b471444f0f3ac4fb9f5a5b542b48824475e0042a5a6"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/29/9c/13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1/asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/07/93/3618b68b4ba6b54bc97b5fd7d90e4981471edfaf51c8321a29a3c76cf47c/asgiref-3.4.1.tar.gz"
    sha256 "4ef1ab46b484e3c706329cedeff284a5d40824200638503f5768edb6de7d58e9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e8/e8/b6cfd28fb430b2ec9923ad0147025bf8bbdf304b1eb3039b69f1ce44ed6e/charset-normalizer-2.0.11.tar.gz"
    sha256 "98398a9d69ee80548c762ba991a4728bfc3836768ed226b3945908d1a688371c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/f2/46/2c1e32574749d38404c9380d5c0de3f6fba44ceea119cf1536f138e72784/httpcore-0.14.7.tar.gz"
    sha256 "7503ec1c0f559066e7e39bc4003fd2ce023d01cf51793e3c173b864eb456ead1"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/59/07/de30dd4bb26131bf34fe82bf721a392ff21e35bb2707ef8cbec954054a23/httpx-0.22.0.tar.gz"
    sha256 "d8e778f76d9bbd46af49e7f062467e3157a5a3d2ae4876a4bbfd8a51ed9c9cb4"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/6e/0c/42cf24a35e97999bf1bdb64c8a27a70ae95ffa72d85090339b7b5404e536/hupper-1.10.3.tar.gz"
    sha256 "cd6f51b72c7587bc9bce8a65ecd025a1e95f1b03284519bfe91284d010316cd9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/b8/a8/facab7275d7d3d2032f375843fe46fad1cfa604a108b5a238638d4615bdc/janus-1.0.0.tar.gz"
    sha256 "df976f2cdcfb034b147a2d51edfc34ff6bfb12d4e2643d3ad0e10de058cb1612"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "Pint" do
    url "https://files.pythonhosted.org/packages/f1/ee/b44c347a8446e1b75404cd7164f90528cacc5f14d55eb073edf240468303/Pint-0.18.tar.gz"
    sha256 "8c4bce884c269051feb7abc69dbfd18403c0c764abc83da132e8a7222f8ba801"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "python-baseconv" do
    url "https://files.pythonhosted.org/packages/33/d0/9297d7d8dd74767b4d5560d834b30b2fff17d39987c23ed8656f476e0d9b/python-baseconv-1.2.2.tar.gz"
    sha256 "0539f8bd0464013b05ad62e0a1673f0ac9086c76b43ebf9f833053527cd9931b"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/46/40/a933ac570bf7aad12a298fc53458115cc74053474a72fbb8201d7dc06d3d/python-multipart-0.0.5.tar.gz"
    sha256 "f7bb5f611fc600d15fa47b3974c8aa16e93724513b49b5f95c81e6624c83fa43"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/03/29/87b9741a98b735851001a0ef3c2c8583ebc61df9b235bd5e94f5f166fbbe/uvicorn-0.17.4.tar.gz"
    sha256 "25850bbc86195a71a6477b3e4b3b7b4c861fb687fb96912972ce5324472b1011"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
