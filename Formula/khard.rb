class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/fd/d6/3172fc469cc09decfb502e5428f6a44b0fec48952ae5afe4d657d9e74ea0/khard-0.18.0.tar.gz"
  sha256 "fe88d4b47fdd948610ac573c01fa13d1b7996265cbc44391085761af9a030615"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409592f6ff6ffea909484fd8c115aa2c4aa6b4b0d0170b42ecddf80dcf249aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b837a9313e783300c92e2896bee4554b7bcf5424dcdb8ebb2485257718eb6f34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "278d880ca2b822670a98a2a7203252859329defdb0ffb3feb4f6ebfc6f940fde"
    sha256 cellar: :any_skip_relocation, ventura:        "5c8a61f99d6b323cae5a95b5ae24b22bc8391a45174e78b5d0718609f5d593b4"
    sha256 cellar: :any_skip_relocation, monterey:       "f87bd7173d4c5cbbaee5c59b0ba1a305646c7b7f575967ff47eb050ed986bcfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "aad76bb070916c7c233d9442cd2ca86e0a1149058cde1bd7ca9834baeac24332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "481e5a7841122a4b4a4b221b0f3cbe56f8215f3267d6950c7ca868a050719553"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "unidecode" do
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
