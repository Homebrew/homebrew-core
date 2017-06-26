class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/warner/magic-wormhole"
  url "https://files.pythonhosted.org/packages/5b/68/3c3958526c905beb9db2d514d7e0bdbf04d44245234d4583a95ec78953a3/magic-wormhole-0.10.1.tar.gz"
  sha256 "8ce5b9e6865b6928e9af89f52f049474507d4c7ca4f68062ecbbff168abb0083"

  bottle do
    cellar :any
    sha256 "130b8a8bb1b3977c9f57ebb3a985e0d3256e3868d5f0e93434602194dbd22e67" => :sierra
    sha256 "f7f4f90b633a38e334245090e6420797123d537f7295fb9d4b70c8267b12ddd3" => :el_capitan
    sha256 "9c61e68cb2157cc9a5ea3e42201d9b685b2ccd650b3d11312de3731fbec33d6e" => :yosemite
  end

  depends_on :python
  depends_on "libsodium"
  depends_on "openssl@1.1"

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
    url "https://files.pythonhosted.org/packages/02/77/8429ed2f7c9adc911e9f362f1c8058f87e209e5dc0273bac37d22fbe0b10/autobahn-17.6.2.tar.gz"
    sha256 "1ff8e62752dc0433e3fa0d1e9735a22d2e6db9644db54332c75f7ab208255ab8"
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
    url "https://files.pythonhosted.org/packages/2a/0c/31bd69469e90035381f0197b48bf71032991d9f07a7e444c311b4a23a3df/cryptography-1.9.tar.gz"
    sha256 "5518337022718029e367d982642f3e3523541e098ad671672a90b82474c84882"
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
    url "https://files.pythonhosted.org/packages/a2/d9/56b6a007a643d6511e616a2be74f67c3703e2aea4e9eaa44bdf48bc78c82/hyperlink-17.2.1.tar.gz"
    sha256 "2c74b35662416f44823d50e59305f761a933723ae6528cc5b0d711361453f28b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
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
    url "https://files.pythonhosted.org/packages/9f/32/80fe4fddeb731b7766cd09fe0b2032a91b43dae655e216792af2a6ae3190/pyOpenSSL-17.0.0.tar.gz"
    sha256 "48abfe9d2bb8eb8d8947c8452b0223b7b1be2383b332f3b4f248fe59ef0bafdd"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/cf/57/d4097cea8caf360ffe0c5d6f25c2cb9317500cdc000fd02a741ba6e64c9e/pyasn1-modules-0.0.9.tar.gz"
    sha256 "be0e4157e4a53551279d6c6e366b080527f5fd068616835b4abf32c14f657f5f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
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
    url "https://files.pythonhosted.org/packages/67/7c/95e5425871bf314e484aea5f8ec65b49ab006944309b496cd53c47646155/tqdm-4.14.0.tar.gz"
    sha256 "284b7cb57c135f41122580df8a818ffffd85449a61365dfb41907d2bf115e88e"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/03/86/2cb7ae81209cc3fc64f68a31d70c20ab4771b520d7e13a5219b1f5e16ee1/txaio-2.8.0.tar.gz"
    sha256 "8029d956591107ff9a2221d2a288fdd3718713a6991f59b97359d3d4f4b7b564"
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
