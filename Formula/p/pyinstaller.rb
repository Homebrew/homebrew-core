class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/2f/51/ee0bc47505096f474390d62500befadc532a9cdd77460d6c46aa1b4e1c51/pyinstaller-6.0.0.tar.gz"
  sha256 "d702cff041f30e7a53500b630e07b081e5328d4655023319253d73935e75ade2"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b683665732bb7b3c7d7bcb6999c393aa5cbf05090584c08f7d7df9990a80ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7979d6856269eab532f78d97b758b1897e0c4522be1739bde3efc14dec1793e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b71f8400b2360e73c16b3f91dd3f386c5e6e1157b3973a19ac87d9a19e9a022"
    sha256 cellar: :any_skip_relocation, ventura:        "05f2077e99c517b32a02eaa463ee28b108eeeef2561df82db72bfffa6f37ba47"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd0ebb8d555277b470a50b8f28108b27f6eab38c77890c4598e647864293d17"
    sha256 cellar: :any_skip_relocation, big_sur:        "193b08fed00df9afae277ff2de5676cfa540bf673460ea33e3460d87572cf79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac0a72a10e361d2c0cfe3cc85601e4ec2a407b8d81c4d18c5ee95beafc020ac"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/ba/0b/0c0557ec47e3159881df337efca70d79d193fae4af43deba196254b668d8/pyinstaller-hooks-contrib-2023.8.tar.gz"
    sha256 "318ccc316fb2b8c0bbdff2456b444bf1ce0e94cb3948a0f4dd48f6fc33d41c01"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
