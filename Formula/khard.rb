class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/19/91/6309d5b0477582b9b663cd65f1346cec6ed5f44e734bac722e1ca2ddc1e3/khard-0.12.2.tar.gz"
  sha256 "9193d2d07cdb69cc6e35a0732111efb92bbfba854a1dd42b4f9c91a52a16c507"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3e0a13e917c8e8b9f6bae079b5d6b95d39886c9ca12e01564b853dd25af9c21" => :mojave
    sha256 "1162f54e63301517898aa57f2662a862e187b3ea2eed50969c920f2b5109c14f" => :high_sierra
    sha256 "9e52f82a2c6189e6d6d0d6f47a725c6ea87beef2054338ff0e1dcf9a4facd0a8" => :sierra
    sha256 "61c299501d8c6395fe825e7858835a35281019e6d35710715e73ee616d6d056b" => :el_capitan
  end

  depends_on "python"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/22/ad/8d19322e77f00f261f2dfe28e22b717f1550b3defe454d3e6b7a9874c48c/ruamel.yaml-0.15.41.tar.gz"
    sha256 "4576b346e86deeebb80eb1b89753f805d9781cfe6111ba4d268f45d2693c8270"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/8d/8b/2c6107d0132fd2309ee870eaee8501808e4e9d950e729a3dfcbd9dfd5b81/vobject-0.9.5.tar.gz"
    sha256 "0f56cae196303d875682b9648b4bb43ffc769d2f0f800958e0a506af867b1243"
  end

  def install
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
