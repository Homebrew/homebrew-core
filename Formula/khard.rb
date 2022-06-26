class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/a3/4e/e9cbcb281d371c355f251e5d9ca58b7e0d02dffd2bf4938888068fbc2def/khard-0.17.0.tar.gz"
  sha256 "164e1aee9264735ec0473a74a38842e6272bbb814d949a66084c6a373bd95618"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe134a1ea2ef4d9a16d959cc5c7fde80fb4a9c8b94c501bf44fbe907fe0721dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fc28b1402c727ebec6e711fb708e60e323fe2b5c626123dea2bf4182fba2098"
    sha256 cellar: :any_skip_relocation, monterey:       "b9bc8806c6ce7690ca5ea73636d8768218de08f492590071fa8f56bda47d72fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbe9d10dec73dfa9c431267ebac08bad479efbbf1b9df9a2e7b1265a7a0b3f8"
    sha256 cellar: :any_skip_relocation, catalina:       "82627b07e76133d8cd6b96411fdbcc9d3be3e13554d81798a6054d9bc8d4161c"
    sha256 cellar: :any_skip_relocation, mojave:         "64336ee4c660ff81770d274d905f236bd32b1dc9a01d9d1bc8ceffcdc3edff6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a3b6a9293dde85e044263c8c948d11df80a08d2afc7e88937bdc9762684c25"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/55/8d/74a75635f2c3c914ab5b3850112fd4b0c8039975ecb320e4449aa363ba54/atomicwrites-1.4.0.tar.gz"
    sha256 "ae70396ad1a434f9c7046fd2dd196fc04b12f9e91ffb859164193be8b6168a7a"
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
    url "https://files.pythonhosted.org/packages/71/81/f597606e81f53eb69330e3f8287e9b5a3f7ed0481824036d550da705cd82/ruamel.yaml-0.17.16.tar.gz"
    sha256 "1a771fc92d3823682b7f0893ad56cb5a5c87c48e62b5399d6f42c8759a583b33"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/a6/93288318cfae2fa0ca978dfe6bb94b22b7e9a9e98b6149a4af00b1e76ee8/Unidecode-1.3.2.tar.gz"
    sha256 "669898c1528912bcf07f9819dc60df18d057f7528271e31f8ec28cc88ef27504"
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
