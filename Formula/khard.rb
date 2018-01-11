class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/58/fd/778ab7340d9fcc1c4853cc19fb12fc4b9c28fe9f48ebc0bb19d42aa4b7bd/khard-0.11.4.tar.gz"
  sha256 "81776d05e8f121f8969daf561f5c774c665378255ba0064b02a82d490da610ea"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d524293bad0d8995bc42ef684dce92cdb850dffb99f0e603f6972cb31de14336" => :high_sierra
    sha256 "97cae8b8351b6524fdb1cc835a3e03564539b3de1114d9e0bcb90889a40fcb6b" => :sierra
    sha256 "85d2a3232587151ee94a78088d61d1e2654bfef94d8f75a620dc1a21ad9d1cdb" => :el_capitan
  end

  depends_on "python3"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/19/8e/6b84b80b14e98b2dcc73c53823850ce3c87899b5992e66a98fddabfd9cc1/vobject-0.9.4.1.tar.gz"
    sha256 "faea7d4fb3e2bc8ef6367e7f9b4ad0841aa1980fd5dd96d05c7a90e39880811c"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
    (etc/"khard").install "misc/khard/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<~EOS
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match /Address book: default/, shell_output("#{bin}/khard list user", 0)
  end
end
