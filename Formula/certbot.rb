class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/74/32/a0ef0c1ea68c72cc579862cfac7aef710fefd09273d802b40dee8e51c991/certbot-1.28.0.tar.gz"
  sha256 "4b54d8cf1f4e372c6755b3f2720ddfd95bad44f619f7473fa388cdd0a7ba8c5c"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c488ee20f5996759cacaf7e57fd6c68265efccd3f813e88ccbf0128029fdd90"
    sha256 cellar: :any,                 arm64_big_sur:  "387f67ce0a67af6a9b05a42b17246286c2a3688072fb83c9f373c203f98bb3c9"
    sha256 cellar: :any,                 monterey:       "48aec37abfcbc9b8f65e1706f4c711583a8b01f2d3027c6e8baa02779ba27992"
    sha256 cellar: :any,                 big_sur:        "8094d3b030da9095dbfb21230f666de971a362aa0858ecda822c46f82ea33034"
    sha256 cellar: :any,                 catalina:       "f7b288079683d2543ef8063c7d79bc21ed460cc59484afdfa2b7a2ee84ed887b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d048165411cfe6f11d9f593d16d16263c086a9e86540fb7c109161c46607cdf"
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
    url "https://files.pythonhosted.org/packages/e8/f7/7f83128c44cb3fe58f6843aeb4b9052c21c67daa2ea8a3760d00105d3be9/acme-1.28.0.tar.gz"
    sha256 "1f822d0f1a4140606c7569333dba97a6df32c17bd0cc996bcdebdf611ee1d589"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
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
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/f4/be/5c1d9decbd5e9cf97dccd40d13c5657bef936d87da03c9d7aeb67c1b5126/josepy-1.13.0.tar.gz"
    sha256 "8931daf38f8a4c85274a0e8b7cb25addfd8d1f28f9fb8fbed053dd51aec75dc9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
