class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/d5/4d/ec706c3fcf39e26888c35b39615ff4d5865d184069666c47492cff1fbe50/pyinstaller-6.21.0.tar.gz"
  sha256 "bb9fab705983e393a2d1cac77d6972513057ad800215fd861dc15ff5272e98fd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c35c6f7706898a62b666a397e741cc157713deddc5c1e65516431770e8b212f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721d7fdad59e9679d654d47798011cc3bd0bd5e272799bcd55f7b36da59e8136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a311ed3472daa1a90a81fa8c53f8e36861ec5a4852bdcc6935eb3bb8e0b23957"
    sha256 cellar: :any_skip_relocation, tahoe:         "55c26f1d7cb7792c5cbf0f57375d55e81161f139a875378805a7be5b751adf67"
    sha256 cellar: :any_skip_relocation, sequoia:       "82476f66681226aad93ebcaf1fb18eec959f4ef19c47a82c24462ac342b81af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "22111dd3d114ae6015fb3b2b87436db2b1a2169f1e9568a9508214acc0c1e33a"
    sha256 cellar: :any,                 arm64_linux:   "ad6e28527b9aa50737c70e7ca6dc4cb105ed0bd0ec54315a08d064f188a5d79a"
    sha256 cellar: :any,                 x86_64_linux:  "102de07f81d873d47e65b4fb5a7991a889b514d4533c50afd119d37e2c5a82e7"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages extra_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/94/5b/c9fe0db5e83ee1c39b2258fa21d23b15e1a60786b6c5990ee5074ead8bb6/pyinstaller_hooks_contrib-2026.6.tar.gz"
    sha256 "bef5002c32f4f50bd55b005da12cff64eca8783e7eaf86a06a62410164bab725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    without = ["macholib"] unless OS.mac?
    virtualenv_install_with_resources(without:)
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end
