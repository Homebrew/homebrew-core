class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/1e/d7/214b25c912d5f7d9c31d266821a8be6a35df80535056fe83997688721927/pyinstaller-5.5.tar.gz"
  sha256 "88993dfc6429dce8dd1f9a73c08e259af71dd3a227d3002ccb8e959151757dc3"
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
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
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
