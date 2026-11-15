class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/6d/43/0e8166583575bd500c0f8f1a4ab9429af9466feb6fcdc006e88de8fd23e9/howdoi-2.0.20.tar.gz"
  sha256 "51cd40c53e0c0f8f8da88f480eb7423183be2350ab4f0a4d9d4763ca6ac3e2a9"
  license "MIT"
  revision 23

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "466185edf37e64608f6619536c8c3631e7966208656aafe358464f9041610752"
    sha256 cellar: :any, arm64_tahoe:       "5c0ea25bad6bfefc54612024d5d7e4a0ab53e8d12b73d0d9f48da9af01f4b95a"
    sha256 cellar: :any, arm64_sequoia:     "33172821ff95e7ba056c2e21e64d374c844b70d0311d4d01577506004c0c9b95"
    sha256 cellar: :any, arm64_linux:       "8dbb605ec2031a27df2751cde0bf060da50567e17261b7155fdfce55dc361a88"
    sha256 cellar: :any, x86_64_linux:      "3a87d9c37d410c2e0882d3dd231793435125e956a8efe643a5682567344a7b94"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachelib" do
    url "https://files.pythonhosted.org/packages/c6/f4/b20875916b83f68775093554ce2544b12255396ba69abd93d8903cce0feb/cachelib-0.17.0.tar.gz"
    sha256 "f3c7dc8d3c1132ab699681ffdf8a52d341d9425ac1401c538cf0b1d87b1677c8"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/c8/8b/dc32df939ab541fca6ee8964d26aa231dbe231cdc2b2713228161441ba9c/cssselect-1.6.0.tar.gz"
    sha256 "8c83a7139e97b93aa5ebdc0f46e785f7056a08a8bf201e597a6a2629d7eb11db"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "keep" do
    url "https://files.pythonhosted.org/packages/60/2b/cff99a6e90eb54f88ea4f96395a788dce3167b95b5e2a93642f16d8a10e2/keep-2.11.tar.gz"
    sha256 "06bc2fbbf65ebebf2c384dca0306a40c3cd531cd95a05c486f5a2b5c07acd94d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/e1/9b/195603d5371861005a3467c5e4afd02fd0698795a2aa36dc41498b9d879d/pygithub-2.10.0.tar.gz"
    sha256 "90ff24ef1cd1bd57124c2a3869cafee9d7b066909129ecdaba2c2d1903bc118d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/c5/d8/955aef5c4ba7e01c67779a9856c4030aa89b6600b78544eae8a22a91185b/pyquery-2.1.0.tar.gz"
    sha256 "75238388750fc6e254b7a52f771027b9beb3a6202b88048bef52a00b0abeadbb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "terminaltables3" do
    url "https://files.pythonhosted.org/packages/55/9b/9abd7feb0cf552061cfa452c22773f3158cdad877ad5623f13edfa07116f/terminaltables3-4.0.0.tar.gz"
    sha256 "4e3eefe209aa89005a0a34d1525739424569729ee29b5e64a8dd51c5ebdab77f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Here are a few popular howdoi commands ", shell_output("#{bin}/howdoi howdoi").split("\n").first
  end
end
