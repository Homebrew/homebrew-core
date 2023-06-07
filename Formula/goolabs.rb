class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 5

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "687e077ba9a88d2cc337d117c73983aa52eba1f74e1a70ce8eed5e4c257682ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce92832e501841a0047e37925789d48ef2d01748cf9530d6bf6f97fca81fa555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b71cccba9bd028e2491025264b9316d6d676ccd3356be799a81fdf379afdab9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6740d2f4f7ee02c00b0cebe378e1441fcbc6f2d841212fd0d62f886431d404f"
    sha256 cellar: :any_skip_relocation, monterey:       "37dcb53e2cd1886c7d519ac99b2320ad4a3f9bc9cdb41c8908ed77be068232f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5a896d144cf1031293a477f2ac0f4a0e58afbc2219a8bb1818757022dca95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f949c309cad72a04621998ea1946297f3593b7e2ca2804d983d62cd10a47c84"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
