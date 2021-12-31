class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/32/61/9a26b8f3dcdb5cb17daff57c9a85be6d5963d50488f45319d64a413da762/fabric-2.6.0.tar.gz"
  sha256 "47f184b070272796fd2f9f0436799e18f2ccba4ee8ee587796fca192acd46cd2"
  license "BSD-2-Clause"
  revision 4
  head "https://github.com/fabric/fabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ec9676b52ecf6b7e5e65b2a536fb1f838b02f76f5ef384ef82bc9978016aea7"
    sha256 cellar: :any,                 arm64_big_sur:  "026dc1ebdf0eed14b4d8d0c391f63374801d4c31707278b618fead6c91de97b4"
    sha256 cellar: :any,                 monterey:       "1a8b762203a27b7600ca72560847e4367e1d772944c311d3b3bf380fe47c0dc1"
    sha256 cellar: :any,                 big_sur:        "daaaa303f70742edbdc5b40d447087a33806981a727c242df9b4b6428ce03ad0"
    sha256 cellar: :any,                 catalina:       "c726617cfedbb3ce32cdbc685e052def43df3a656339e7fd85ee37e8c000bc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c696886c70249c5a417132c90cbf1187f1b9c3c23c8ec015ad77722a417ddeb"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/37/b3/0b88358ee07789688d17ec7074a656da68ced50a122183187be12928b535/invoke-1.6.0.tar.gz"
    sha256 "374d1e2ecf78981da94bfaf95366216aaec27c2d6a7b7d5818d92da55aa258d3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/01/78/bc696bac815e17af33b804f1d30525b7954bcfdec4bb9df8ef9bc77c52c4/paramiko-2.9.1.tar.gz"
    sha256 "a1fdded3b55f61d23389e4fe52d9ae428960ac958d2edf50373faa5d8926edd0"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/df/16/e9d6bcf1aed52a55bc1696324ab22586716053b3e97b85266e0f3ad36bae/pathlib2-2.3.6.tar.gz"
    sha256 "7d8bcb5555003cdf4a8d2872c538faa3a0f5d20630cb360e518ca3b981795e5f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~EOS
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    EOS
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
