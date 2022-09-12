class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/18/9e/dbee87c405633be8ae926520d5e91c29cd76c969328ad4c724e6983e2b58/pyinstaller-5.4.1.tar.gz"
  sha256 "2a09e6bd6e121eb1a71fadb223797dc502e4fd4168931c31a5f87faa10eb5b4c"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbd9e8cdb6c4e523f132d813748462283e13292928adcbc355687a265647a4a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ac8277e358d0cc435517078632ce1ac09b28e68c61d94be40cf27065edd81f6"
    sha256 cellar: :any_skip_relocation, monterey:       "21e2e3a5c91e55cdead9f48e6605b6d9c9f87e9b7d1f56b9949a6e0068456640"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac336ef4c373b1e8e05bcd0b19ccb6b49900c9931377760df968242da6096f77"
    sha256 cellar: :any_skip_relocation, catalina:       "64f0e1d0770a745b753a271b4657dcb32290ef3c00a64839db486422b0768f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1453c0f56101dba069b94c17cf45eef6741cf5b9b014be17580b4e1ddab610b6"
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
    url "https://files.pythonhosted.org/packages/8d/46/5b21e3eedc41fe0a8522e409ab2c71ebf137eab0f9e632c5213e76f97b7e/pyinstaller-hooks-contrib-2022.10.tar.gz"
    sha256 "e5edd4094175e78c178ef987b61be19efff6caa23d266ade456fc753e847f62e"
  end

  def install
    cd "bootloader" do
      system "python3.10", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
