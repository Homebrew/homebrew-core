class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/5d/9c/e0ac62602f768f7a69f8a6386610cfb1f80886f7fcbceb3cd8cb05dd93f7/certbot-1.20.0.tar.gz"
  sha256 "ea26b9f28e347d8c5c6f6c697c65e333c0660ca93ffd5444ba20d1bc6a5f0d0a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "27fe50d87365b327dc2e2075a49c71177ac290de28a117c283a829392a606d9d"
    sha256 cellar: :any,                 arm64_big_sur:  "8e8e9491709490f18bf78b3946de500f4e68991d7efe4d89b98c0930e7a075ad"
    sha256 cellar: :any,                 monterey:       "355845f316a1dd2888974bca7e5a0b2c300a24bf953ac32307f32e1206f01f61"
    sha256 cellar: :any,                 big_sur:        "f8411f967170651ccad453f6a835625a897941f98b9ae6d0cc724333e25a233c"
    sha256 cellar: :any,                 catalina:       "9f89f2bd5ec8292d5014700d5d6a8e430153872e7257cb8262e0a90359e153ba"
    sha256 cellar: :any,                 mojave:         "8cae8029efe172515037f735734b8db8419dd3479b863b8353f4bce7a0305ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5304bc1e71558a7aa6298715c7415e33a4f02832321d5b512a09d5aac66835f"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "acme" do
    url "https://files.pythonhosted.org/packages/63/9d/47667b4bfff8beb1838351f14c26b73377f60e1dbc5b3cb95c7f738f1da6/acme-1.20.0.tar.gz"
    sha256 "0ddfde8d8e574d35af2bf1d1648b6bdb359c82e257e39d6b074e35136777016e"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/f9/5e/b02b98227ee55b636b6e31dcc55e0c8f95d71fce5347626966ce6ff52060/certbot-apache-1.20.0.tar.gz"
    sha256 "b964fef5a77d0f0b702fb82929d22aeb93dcdc9f8c74f368112fcdf069544dbc"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/31/8a/ab9b48dda5eb837239e008db6a4f825f31906df7da89374d0a3037e812a8/certbot-nginx-1.20.0.tar.gz"
    sha256 "24f16680c0b7931986ea690a31ddb7ebfa7f8435211cd71b19af95c1de9b8ea4"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/27/21/e228c5931c18882419590d5cb5306f124f7eb653146c7918efe78c81b553/josepy-1.10.0.tar.gz"
    sha256 "e9bcaf605411cadaec04841ae2d5f77ebb178b7b6df7c9aed1d97399ac18685b"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/54/9a/2a43c5dbf4507f86f7c43cba4195d5e25a81c988fd7b0ea779dfc9c6973f/pyOpenSSL-21.0.0.tar.gz"
    sha256 "5e2d8c5e46d0d865ae933bef5230090bdaf5506281e9eec60fa250ee80600cb3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/c5/c0/64931e1e8f2bfde9d8bc01670de2d2a395efcf8f49d3a9daa21cf3ffee2b/zope.component-5.0.1.tar.gz"
    sha256 "32cbe426ba8fa7b62ce5b211f80f0718a0c749cc7ff09e3f4b43a57f7ccdf5e5"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/30/00/94ed30bfec18edbabfcbd503fcf7482c5031b0fbbc9bc361f046cb79781c/zope.event-4.5.0.tar.gz"
    sha256 "5e76517f5b9b119acf37ca8819781db6c16ea433f7e2062c4afc2b6fbedb1330"
  end

  resource "zope.hookable" do
    url "https://files.pythonhosted.org/packages/10/6d/47d817b01741477ce485f842649b02043639d1f9c2f50600052766c99821/zope.hookable-5.1.0.tar.gz"
    sha256 "8fc3e6cd0486c6af48e3317c299def719b57538332a194e0b3bc6a772f4faa0e"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/ae/58/e0877f58daa69126a5fb325d6df92b20b77431cd281e189c5ec42b722f58/zope.interface-5.4.0.tar.gz"
    sha256 "5dba5f530fec3f0988d83b78cc591b58c0b6eb8431a85edd1569a0539a8a5a0e"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/certbot"
    pkgshare.install buildpath/"examples"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
