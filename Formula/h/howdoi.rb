class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/6d/43/0e8166583575bd500c0f8f1a4ab9429af9466feb6fcdc006e88de8fd23e9/howdoi-2.0.20.tar.gz"
  sha256 "51cd40c53e0c0f8f8da88f480eb7423183be2350ab4f0a4d9d4763ca6ac3e2a9"
  license "MIT"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "775acb6c3d03ba492ed88ebe99bb791b553a080c88ae317c209357e0723a26d1"
    sha256 cellar: :any,                 arm64_sequoia: "55de969050372eb60e9b51eaac934786973c2ba6fa077785519d140b57228488"
    sha256 cellar: :any,                 arm64_sonoma:  "8e5a52d9232691973a0f1d435fc6bb2290e71b174a0abefb5601cb6829373f00"
    sha256 cellar: :any,                 sonoma:        "292df168fb691b2a97d0f08fce042d959d145bd338fa35df58686b44aaa74d7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03f7fe8c2f0d20f50d64ab0964ad5377e00c0b1d24c405d4684071bb7375f1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "866f966f61723f46dff5ab204dfcbde1988a25410d8b92ed3b819dbac792bbad"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachelib" do
    url "https://files.pythonhosted.org/packages/1d/69/0b5c1259e12fbcf5c2abe5934b5c0c1294ec0f845e2b4b2a51a91d79a4fb/cachelib-0.13.0.tar.gz"
    sha256 "209d8996e3c57595bee274ff97116d1d73c4980b2fd9a34c7846cd07fd2e1a48"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "keep" do
    url "https://files.pythonhosted.org/packages/60/2b/cff99a6e90eb54f88ea4f96395a788dce3167b95b5e2a93642f16d8a10e2/keep-2.11.tar.gz"
    sha256 "06bc2fbbf65ebebf2c384dca0306a40c3cd531cd95a05c486f5a2b5c07acd94d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/c1/74/e560bdeffea72ecb26cff27f0fad548bbff5ecc51d6a155311ea7f9e4c4c/pygithub-2.8.1.tar.gz"
    sha256 "341b7c78521cb07324ff670afd1baa2bf5c286f8d9fd302c1798ba594a5400c9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/ae/48/79e774ea00b671d08867f06d9258203be81834236c150ac00e942d8fc4db/pyquery-2.0.1.tar.gz"
    sha256 "0194bb2706b12d037db12c51928fe9ebb36b72d9e719565daba5a6c595322faf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "terminaltables3" do
    url "https://files.pythonhosted.org/packages/55/9b/9abd7feb0cf552061cfa452c22773f3158cdad877ad5623f13edfa07116f/terminaltables3-4.0.0.tar.gz"
    sha256 "4e3eefe209aa89005a0a34d1525739424569729ee29b5e64a8dd51c5ebdab77f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Here are a few popular howdoi commands ", shell_output("#{bin}/howdoi howdoi").split("\n").first
  end
end
