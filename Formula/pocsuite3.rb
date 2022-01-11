class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  url "https://files.pythonhosted.org/packages/dd/36/f81e3ea521877a86ce0ab19c279b6c52f2ba7c464fb2830a21f08f437b03/pocsuite3-1.8.10.tar.gz"
  sha256 "04e3b244633119a427a31e94cbad20e1d8b6b81d9f0eca6f28da0f601e4c8dc4"
  license "GPL-2.0-only"
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528527f518a0e7679b62d7b781aa08072d531292e0e72f40a6dc37741c173579"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74c0f5938db3d327c3921f8cb7bc9fc15efe624df9c798c0a5633c8fd28d7f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a32b551bbc324ed91cbb49c4afd738671340cb45152878b4ab0d10bc233ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa384bd46fa88d304c86c389221a19b1aa0c81d8f1d062e29f6f5dd388fc3d9"
    sha256 cellar: :any_skip_relocation, catalina:       "9f8c9a644646dc401105b63dc8336d4519ee21dab288580a38ff1a40cbcc0531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09f2288f646689d0d80a2b968980f946b41a2b0e161e19e08d40f933933ff66"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "Faker" do
    url "https://files.pythonhosted.org/packages/9c/c9/c506f4e6e2c7a0f766d80fe5f043a2bfc4dbaf6e381717224583646ca15e/Faker-11.3.0.tar.gz"
    sha256 "adbe567e64da6a1097feacab699000e1ad16e17a6592a8f0ae1ee0b7fbf19887"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/71/19/d65d4c39aa12a5630a8aa02ead8324cfaae3217146b19dd25d88d763bbdf/prettytable-3.0.0.tar.gz"
    sha256 "69fe75d78ac8651e16dd61265b9e19626df5d630ae294fc31687aa6037b97a58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f6/06/e2ad9e93210790be86d36c6e2d5524ba54928c3ed27dd0be9b2ced7c57f1/pycryptodomex-3.12.0.zip"
    sha256 "922e9dac0166e4617e5c7980d2cff6912a6eb5cb5c13e7ece222438650bd7f66"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/85/47/c919432ca258f354bb2c1e645623f891603f185bfc7563d4a21f6432e7ed/scapy-2.4.5.tar.gz"
    sha256 "bc707e3604784496b6665a9e5b2a69c36cc9fb032af4864b29051531b24c8593"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -r ecshop_rce.py --options")
  end
end
