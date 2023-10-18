class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/fd/d6/3172fc469cc09decfb502e5428f6a44b0fec48952ae5afe4d657d9e74ea0/khard-0.18.0.tar.gz"
  sha256 "fe88d4b47fdd948610ac573c01fa13d1b7996265cbc44391085761af9a030615"
  license "GPL-3.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa6f96e3c862e1106626a92ab49259c6727c6022572765740453f22df063f516"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1d700154a7cfc77a5689e3423a6d5a7b67cf47fc41ca2fd102f19da4565df5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca8f586f030fb1d4f5fc8c676c4b2bfb3eb3659560d3056f93c9fe3713d06f76"
    sha256 cellar: :any_skip_relocation, sonoma:         "73dc7c3b7dfe4fe4818c2d4f2ed2f67eaa8528d4322dd8181c6d04adc218df8e"
    sha256 cellar: :any_skip_relocation, ventura:        "20c4a1423f75e6aa7fcf86b398dad7eee5a2a43550f733d8dab15793a5d8d253"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7365a892568d193c6480b5534704977e5889f46eff0f7d8845f84f908c9ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b34d8d8bec612e7991794858cf4e23ad465e6f91735fd847c17301b06bd1f7a"
  end

  depends_on "python@3.12"
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
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/80/5d/f156f6a7254ecc0549de0eb75f786d2df724c0310b97c825383517d2c98d/Unidecode-1.3.7.tar.gz"
    sha256 "3c90b4662aa0de0cb591884b934ead8d2225f1800d8da675a7750cbc3bd94610"
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
