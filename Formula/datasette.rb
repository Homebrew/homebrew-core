class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/3b/a4/94c7628bb167486190c4806c5d623cfe0376037197602db3b1716f92a9da/datasette-0.59.1.tar.gz"
  sha256 "4e36b411811ce6c853483561c544dfc061bef1e59f183c696c9695b146ccc239"
  license "Apache-2.0"
  head "https://github.com/simonw/datasette.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01df33da5138d371a0f53c3d35d866b81510880bac6f212389595f333b007868"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9d01bcbb204aeccb091861c956d1bb9f1685a05472c754803af52b65372c530"
    sha256 cellar: :any_skip_relocation, catalina:      "827ed00fd1d16a5761316d2e1e5e9aa13a54d67be044969a423dc7ce6284cd86"
    sha256 cellar: :any_skip_relocation, mojave:        "f469e1e792acf7c2cf93f6b89bee2f9c43292429ee04ee7a481a64871183dfca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d909d0522386982b7445960f36d9c1131be2aaa626eb4eaaa3bae219a9606b"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/66/02/ca9061e93c487a897859e3a41f6c1a4f494038d2791382169b9a0c528175/anyio-3.3.4.tar.gz"
    sha256 "67da67b5b21f96b9d3d65daa6ea99f5d5282cb09f50eb4456f8fb51dffefc3ff"
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
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
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
    url "https://files.pythonhosted.org/packages/6a/90/334411fe5455d30498add7d77a8bf4833bfc4671289a954fb2fd43795338/httpcore-0.13.7.tar.gz"
    sha256 "036f960468759e633574d7c121afba48af6419615d36ab8ede979f1ad6276fa3"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/62/0d/9804c841eaf5e0f72890e54eff21bb49664289edf8cbe09bd47db513bd68/httpx-0.20.0.tar.gz"
    sha256 "09606d630f070d07f9ff28104fbcea429ea0014c1e89ac90b4d8de8286c40e7b"
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
    url "https://files.pythonhosted.org/packages/fc/8e/92fcb2ff18797959cde050b7c96a713999f73feefde809bfdf18b5901174/janus-0.6.2.tar.gz"
    sha256 "127edc891f9e13420dd12f230d5113fa3de7f93662b81acfaf845989edf5eebf"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f8/86/7c0eb6e8b05385d1ce682abc0f994abd1668e148fb52603fa86e15d4c110/Jinja2-3.0.2.tar.gz"
    sha256 "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45"
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
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "Pint" do
    url "https://files.pythonhosted.org/packages/8d/ac/3ec9b2692e17db4d99d1b9af8c68a45a2c37aab714c1c0320a3a6f1601e0/Pint-0.17.tar.gz"
    sha256 "f4d0caa713239e6847a7c6eefe2427358566451fe56497d533f21fb590a3f313"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/31/c9/b29ea153b9bffaae787ecc81873b4b51bd36cc13c37586b41891beae37eb/pyparsing-3.0.1.tar.gz"
    sha256 "84196357aa3566d64ad123d7a3c67b0e597a115c4934b097580e5ce220b91531"
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

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/3c/06/758c0ce8fe0053a86c99824c69eaabf0dacf2a0d935a9cfde18bbef9360a/uvicorn-0.15.0.tar.gz"
    sha256 "d9a3c0dd1ca86728d3e235182683b4cf94cd53a867c288eaeca80ee781b2caff"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
