class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/a3/4e/e9cbcb281d371c355f251e5d9ca58b7e0d02dffd2bf4938888068fbc2def/khard-0.17.0.tar.gz"
  sha256 "164e1aee9264735ec0473a74a38842e6272bbb814d949a66084c6a373bd95618"
  license "GPL-3.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc819763201a7c29c325be259fd5c28832d0a54719327f3eb5cccf3437560a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adec0c167f9673be452f1c695a832835f46da17700bba0df78b053c80db69c5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28ed6dc0506b9f6434caae9cb9294f7fdbacfdba3d54483f6a0bd33a97bdb95a"
    sha256 cellar: :any_skip_relocation, ventura:        "f70d695cf222879e763004ec96e0d0df0c6e38aa7f6d686c2823047c278305bc"
    sha256 cellar: :any_skip_relocation, monterey:       "4926349ad3de43a969e15f153fd405f44600f7d728d36e67a3f553f583ced621"
    sha256 cellar: :any_skip_relocation, big_sur:        "3383947a6a566b663728df7b3a790941093b515fc38dea6fdd190e0c339bdd19"
    sha256 cellar: :any_skip_relocation, catalina:       "8708b26b71a7cb95b39279b1a653ffcc3ea37f203dcf05dc3fd8fbb6893e3152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3831e654b813d9c219fc06d9cfa5094c0ff495e958b7326236ee05cd8558c2"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/0b/25/37c77fc07821cd06592df3f18281f5e716bc891abd6822ddb9ff941f821e/Unidecode-1.3.6.tar.gz"
    sha256 "fed09cf0be8cf415b391642c2a5addfc72194407caee4f98719e40ec2a72b830"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/da/ce/27c48c0e39cc69ffe7f6e3751734f6073539bf18a0cfe564e973a3709a52/vobject-0.9.6.1.tar.gz"
    sha256 "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101"
  end

  def install
    virtualenv_install_with_resources
    (etc/"khard").install "doc/source/examples/khard.conf.example"
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
    assert_match "Address book: default", shell_output("#{bin}/khard list user")
  end
end
