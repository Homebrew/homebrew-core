class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/warner/magic-wormhole"
  url "https://files.pythonhosted.org/packages/6c/9f/6383d6eec761ce97d8a80693871dd87edfd2d3e3a0c9439e2836a67a0ff5/magic-wormhole-0.10.3.tar.gz"
  sha256 "48465d58f9c0d729dc586627cf280830e7ed59f9e7999946ae1d763c6b8db999"
  revision 2

  bottle do
    cellar :any
    sha256 "75f24e4670554f4d07a8b448cfaec88a6841df7fd534fb530f0b4b685fd07ed7" => :high_sierra
    sha256 "a0fbf57f910a408c982dd7fa2c59e5544b16304c5a9ba7d9eb9b3cc40ab73409" => :sierra
    sha256 "23086ef8102f30e8c7bbd7aa6af42767af213b8eee73e17519a54c90eb831e3e" => :el_capitan
  end

  depends_on "libsodium"
  depends_on "openssl"
  depends_on "python"

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/de/05/b8e453085cf8a7f27bb1226596f4ccf5cc9e758377d60284f990bbdc592c/Automat-0.6.0.tar.gz"
    sha256 "3c1fd04ecf08ac87b4dd3feae409542e9bf7827257097b2b6ed5692f69d6f6a8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/8d/f3/02605b056e465bf162508c4d1635a2bccd9abd1ee3ed2a1bb4e9676eac33/PyNaCl-1.1.2.tar.gz"
    sha256 "32f52b754abf07c319c04ce16905109cab44b0e7f7c79497431d3b2000f8af8c"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/31/bf/7f86a8f8b9778e90d8b2921e9f442a8c8aa33fd2489fc10f236bc8af1749/Twisted-17.5.0.tar.bz2"
    sha256 "f198a494f0df2482f7c5f99d7f3eef33d22763ffc76641b36fec476b878002ea"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/be/41/e909cb6d901e9689da947419505cc7fb7d242a08a62ee221fce6a009a523/attrs-17.2.0.tar.gz"
    sha256 "5d4d1b99f94d69338f485984127e4473b3ab9e20f43821b0e546cc3b2302fd11"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/17/71/898dbf715057e720b01e351f2b00d881cf1066c0d0dd719446e930de6818/autobahn-17.9.2.tar.gz"
    sha256 "15758e1f507d191a0b56dca911eba780d12e603e0a4567bd2ec0ec08bf08cd4c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
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
    url "https://files.pythonhosted.org/packages/83/df/3bdaf38f21f93429de02f04c6a967d2154955fc5b9a6a1a0b20a682edc13/hyperlink-17.3.1.tar.gz"
    sha256 "bc4ffdbde9bdad204d507bd8f554f16bba82dd356f6130cb16f41422909c33bc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"
    sha256 "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/ee/6a/cd78737dd990297205943cc4dcad3d3c502807fd2c5b18c5f33dc90ca214/pyOpenSSL-17.3.0.tar.gz"
    sha256 "29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/1a/37/7ac6910d872fdac778ad58c82018dce4af59279a79b17403bbabbe2a866e/pyasn1-0.3.4.tar.gz"
    sha256 "3946ff0ab406652240697013a89d76e388344866033864ef2b097228d1f0101a"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/66/6b/f5582cbf3b920896ce1b97bde3894599b3dec31301ef79ae7ea0022f5577/pyasn1-modules-0.1.4.tar.gz"
    sha256 "b07c17bdb34d6f64aafea6269f2e8fb306a57473f0f38d9a6ca389d6ab30ac4a"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "service_identity" do
    url "https://files.pythonhosted.org/packages/de/2a/cab6e30be82c8fcd2339ef618036720eda954cf05daef514e386661c9221/service_identity-17.0.0.tar.gz"
    sha256 "4001fbb3da19e0df22c47a06d29681a398473af4aa9d745eca525b3b2c2302ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/10/7d/7e815d8e25ddd08edd46dc5202e3b30c61d15a68c0166e03a4dd37a18466/spake2-0.7.tar.gz"
    sha256 "d2281458eed1048cb12fbab6ac02b06a8520ae9f2c30be330ea4c5b558a4b766"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/01/f7/2058bd94a903f445e8ff19c0af64b9456187acab41090ff2da21c7c7e193/tqdm-4.15.0.tar.gz"
    sha256 "6ec1dc74efacf2cda936b4a6cf4082ce224c76763bdec9f17e437c8cfcaa9953"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/d6/95/d0c67304515f352342bc8fd14e5a3e7ca924134608acb730916073b18464/txaio-2.8.2.tar.gz"
    sha256 "484cd6c4cdd3f6081b87188f3b2b9a36e02fba6816e8256917c4f6571b567571"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/05/4b/d2fbfdc08ab83c299f2ad22ba38ea35f71f1c966684f5754e079108a1f64/txtorcon-0.19.3.tar.gz"
    sha256 "f73396667909a3c7a98f4dd865edf4ed6a2518ee5a935d92e18b8a479ec244fd"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/c5/88/93373971f893714f0dc15e09696ec4886ee8b4e561ce5ae45612c2c516c4/zope.interface-4.4.2.tar.gz"
    sha256 "4e59e427200201f69ef82956ddf9e527891becf5b7cde8ec3ce39e1d0e262eb0"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
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
