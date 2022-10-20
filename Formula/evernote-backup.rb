class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https://github.com/vzhd1701/evernote-backup"
  url "https://files.pythonhosted.org/packages/c6/2e/28f97f59b92edde07895d6c95596b99313bb1a2cd0296ac2fd36f8954cb4/evernote-backup-1.9.2.tar.gz"
  sha256 "ec21025d614ec68ed5dc8d2028f2f856630a36b3b84f135952660bec7bdf70ad"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16938ebbc8f80c8e57851246c7bc57486c80a7b2f0d1cf77776a018faf0bdcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e88e10f928b33db0592575b4f68712a202f7621ac71c1587e4a52bfb235374e2"
    sha256 cellar: :any_skip_relocation, monterey:       "ec45b8f7f6131d38cc00167633021f11b7fbb3867eb1a36cf06f123b1a6f7d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "6567d73bc5a78432d0cbc9922657bfdc64e14342f8016b0291f0c07a7656aa6a"
    sha256 cellar: :any_skip_relocation, catalina:       "42b24987e64b0ac8a9e8501268c87baa41274651a265f023ecfbb5cb726c9be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81dc114c62964b0a8a5e7570d5753a42e40ad9828c5153824655900856356850"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/3c/86/5de6d909d9dcc85627a178788ec3e8c3ef81cda175badb48ad0bb582628d/click-option-group-0.5.3.tar.gz"
    sha256 "a6e924f3c46b657feb5b72679f7e930f8e5b224b766ab35c91ae4019b4e0615e"
  end

  resource "evernote3" do
    url "https://files.pythonhosted.org/packages/7c/7e/2da47f29c4b1a14945ef143a3b784d50dd9d73595a4c397f34fa481a4e5c/evernote3-1.25.14.tar.gz"
    sha256 "e7914bb7cefb30e0ea509e82e1f176670359a154e30006f5160a0bcfd936cfd0"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "oauth2" do
    url "https://files.pythonhosted.org/packages/64/19/8b9066e94088e8d06d649e10319349bfca961e87768a525aba4a2627c986/oauth2-1.9.0.post1.tar.gz"
    sha256 "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/evernote-backup init-db -u test -p test 2>&1", 1)
    assert_match "Password login disabled", output

    assert_match version.to_s, shell_output("#{bin}/evernote-backup --version")
  end
end
