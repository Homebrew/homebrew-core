class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/c9/41/fbb2f0e6e1934a47a99295d67ba178477f8809ae939c96608c711596f478/pyinstaller-5.1.tar.gz"
  sha256 "9596c70c860cbce19537354db95b180351959b4cd14a70db6ab1d1432668c313"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6e03804e1676310f50aaac061ba4fbbde1cb5e9bce72747e5da4f25ba28188"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2960c2033f41a3649b09e0c88f186fb461b69e077e478be47bcff82f980fe171"
    sha256 cellar: :any_skip_relocation, monterey:       "f5de29bf658db9778d204f7688d09490d8b1406248ca9027295bcf116aebbd5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6060cc43e7668a561a22c8be59de483cb5590bbb1a34f2bf8ae6cb83076b007a"
    sha256 cellar: :any_skip_relocation, catalina:       "470ddb2a7762e66557c381da5bc1a550077c8e84008661c72ab3f573084b878b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc9926a550721ac536df12b3880e9e92f2aa23651a34f536b1a0dcff1d6bc6c"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/16/1b/85fd523a1d5507e9a5b63e25365e0a26410d5b6ee89082426e6ffff30792/macholib-1.16.tar.gz"
    sha256 "001bf281279b986a66d7821790d734e61150d52f40c080899df8fefae056e9f7"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/b3/8c/c390f589d257717dbb6725147dc3dff89e832c432ac59aa8c1c74030746f/pyinstaller-hooks-contrib-2022.5.tar.gz"
    sha256 "90a05207ceea2f8c166f12c3add46e24c0ed6a78234e5f99320f8683d56e0dec"
  end

  def install
    cd "bootloader" do
      system "python3", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
