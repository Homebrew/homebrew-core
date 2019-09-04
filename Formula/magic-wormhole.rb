class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/warner/magic-wormhole"
  url "https://files.pythonhosted.org/packages/77/15/9438290bab8146efc0213f7c3d9645d9bc5a2e885e4049477e7432e40336/magic-wormhole-0.11.2.tar.gz"
  sha256 "ae79667bdbb39fba7d315e36718db383651b45421813366cfaceb069e222d905"
  revision 1

  bottle do
    cellar :any
    sha256 "9e23e7330c2d66f365abf00390d2fa9826f80aab0c78cdf85ddfa8b9c21e626e" => :mojave
    sha256 "71a0b343f89f7f1d8b4afd361f2fd7b3d98243544a92a80fecee19c360c42d4f" => :high_sierra
    sha256 "c1e49d96bf4e556bd142e1d82da454477c4b43b4b62570542e3243c5afc81109" => :sierra
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "python"

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/4a/4f/64db3ffda8828cb0541fe949354615f39d02f596b4c33fb74863756fc565/Automat-0.7.0.tar.gz"
    sha256 "cbd78b83fa2d81fe2a4d23d258e1661dd7493c9a50ee2f1a5b2cac61c1793b0e"
  end

  resource "PyHamcrest" do
    url "https://files.pythonhosted.org/packages/a4/89/a469aad9256aedfbb47a29ec2b2eeb855d9f24a7a4c2ff28bd8d1042ef02/PyHamcrest-1.9.0.tar.gz"
    sha256 "8ffaa0a53da57e89de14ced7185ac746227a8894dbd5a3c718bf05ddbd1d56cd"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/79/59/035de19362320e632301ed7bbde23e4c8cd6fc5e2f1cf8d354cdba857854/Twisted-19.2.1.tar.bz2"
    sha256 "fa2c04c2d68a9be7fc3975ba4947f653a57a656776f24be58ff0fe4b9aaf3e52"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813/attrs-19.1.0.tar.gz"
    sha256 "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/a0/fd/6b2405331986fad5c320cac3516bc276a20beecc6f66ade0cbd38d37504a/autobahn-19.6.2.tar.gz"
    sha256 "48c2d737d33cfe1d37124db984577c5d4f44e116d05a9f8b6505721413ff9b22"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/c2/95/f43d02315f4ec074219c6e3124a87eba1d2d12196c2767fadfdc07a83884/cryptography-2.7.tar.gz"
    sha256 "e6347742ac8f35ded4a46ff835c60e68c22a536a8ae5c4422966d06946b6d4c6"
  end

  resource "hkdf" do
    url "https://files.pythonhosted.org/packages/c3/be/327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935f/hkdf-0.0.3.tar.gz"
    sha256 "622a31c634bc185581530a4b44ffb731ed208acf4614f9c795bdd70e77991dca"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/e0/46/1451027b513a75edf676d25a47f601ca00b06a6a7a109e5644d921e7462d/hyperlink-19.0.0.tar.gz"
    sha256 "4288e34705da077fada1111a24a0aa08bb1e76699c9ce49876af722441845654"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"
    sha256 "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/ec/0b/69620cb04a016e4a1e8e352e8a42717862129b574b3479adb2358a1f12f7/pyasn1-modules-0.2.5.tar.gz"
    sha256 "ef721f68f7951fab9b0404d42590f479e30d9005daccb1699b0a51bb4177db96"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "service_identity" do
    url "https://files.pythonhosted.org/packages/9a/3d/9eb0563e066ea0540cf580695593ab079376e920016d4d1b3ff2fd8abf4b/service_identity-18.1.0.tar.gz"
    sha256 "0858a54aabc5b459d1aafa8a518ed2081a285087f349fe3e55197989232e2e2d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/60/0b/bb5eca8e18c38a10b1c207bbe6103df091e5cf7b3e5fdc0efbcad7b85b60/spake2-0.8.tar.gz"
    sha256 "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/d0/0a/50a145091ce0c02db89d0342a59327c1ddeee206ef2991f09158d4e52406/tqdm-4.32.2.tar.gz"
    sha256 "25d4c0ea02a305a688e7e9c2cdc8f862f989ef2a4701ab28ee963295f5b109ab"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/c1/99/81de004578e9afe017bb1d4c8968088a33621c05449fe330bdd7016d5377/txaio-18.8.1.tar.gz"
    sha256 "67e360ac73b12c52058219bb5f8b3ed4105d2636707a36a7cdafb56fe06db7fe"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/b7/93/e16d8160bac3a19d13c9ead9ac6b38f837f2534d40884109a334be1f849c/txtorcon-19.0.0.tar.gz"
    sha256 "3731b740653e3f551412744f1fcd7fa6f04aa9fa37c90dc6c9152e619886bf3b"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz"
    sha256 "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi")
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    end
    sleep 1
    begin
      received = shell_output("#{bin}/wormhole receive #{n}-homebrew-test")
      assert_match received, "foo\n"
    ensure
      Process.wait(pid)
    end
  end
end
