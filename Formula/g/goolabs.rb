class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a1d34da66fd03fa5da047b4e6144c7acf4f15309d70a4faa9f3bf0fdbed8851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce3eb814ae9d895ae64c6c0ce255992c9ffff1c5dabaed134322046896865758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ec88dd65e045f3b875f514f7e234a414fde1ec2514677eb3118bc8d1c4d449"
    sha256 cellar: :any_skip_relocation, sonoma:         "02b38c406170fec8af8fdbb31172fa993b491a68534d81d0b0f87a0b5b40b371"
    sha256 cellar: :any_skip_relocation, ventura:        "bf5a204e2a42c48c5da2639eb7bf7324fc786abd461ef3c57912a81c92f15549"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcda3bfe1bcd8b2150eaed557a2d7e17c47d1c568bce8154396e0ee76baac86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f647470a7f7edba2ec6930191481d2d5f4982531457def2a54d5caa646bdf70b"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
