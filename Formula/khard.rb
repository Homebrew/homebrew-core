class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/fd/d6/3172fc469cc09decfb502e5428f6a44b0fec48952ae5afe4d657d9e74ea0/khard-0.18.0.tar.gz"
  sha256 "fe88d4b47fdd948610ac573c01fa13d1b7996265cbc44391085761af9a030615"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd1e2cf55cf4db6d949fb5d323ae5f012879b708509e42ca653063219646b457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74d3bb85f5dffdd698f66e289163ec068a4dd20f40063bee9430cee827283d44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b17fcb88bffbe52279883633a3ade7c39eb89b82495f6f8013f795d0f22c8c1"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a97ec63cdef5c1e383053591966a0ca5872b9b96f0a733431611567551c475"
    sha256 cellar: :any_skip_relocation, monterey:       "1966589c1fbf696ab701e65f171ec517601a3de20f05d01a0f484767b2603ed1"
    sha256 cellar: :any_skip_relocation, big_sur:        "80506ea07260b9e958ad9e41b752308ba6b1b963585aa30a7919f94e412e0042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ecdd8b889de9800958f6b364b1399bd2bbe22e5dd64380dede70bc012172a2d"
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
