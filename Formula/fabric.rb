class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.13.1.tar.gz"
  sha256 "59ee3b780e0cd3b8c5db7333d2006a5f932e8e79e2f334aec76c6f97b298bac6"
  revision 2

  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any
    sha256 "c8c91ac29a5a9bf9e3d9dc80cfffd350ed57c0dbcff877c535e01f26596a6eb9" => :sierra
    sha256 "070b0d545fab86c0d5f14042ef99dd4e4930ba25b05ac7a91467eb778af6a2d1" => :el_capitan
    sha256 "b8683be1be214bdefa003b315ba9d116e80da46477786c89b9e0dc8ac86eb665" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/ce/39/17e90c2efacc4060915f7d1f9b8d2a5b20e54e46233bdf3092e68193407d/asn1crypto-0.21.1.tar.gz"
    sha256 "4e6d7b22814d680114a439faafeccb9402a78095fb23bf0b25f9404c6938a017"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/64/79/5e8baeedb6baf1d5879efa8cd012f801efc232e56a068550ba00d7e82625/paramiko-2.1.2.tar.gz"
    sha256 "5fae49bed35e2e3d45c4f7b0db2d38b9ca626312d91119b3991d0ecf8125e310"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<-EOS.undent
      from fabric.api import task, puts, env
      @task
      def hello():
        puts("fabric " + env.version)
    EOS
    expected = <<-EOS.undent
      fabric #{version}

      Done.
    EOS
    assert_equal expected, shell_output("#{bin}/fab hello")
  end
end
