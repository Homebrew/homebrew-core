class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/cf/b0/69585629b023056e801a99ee4d669e2d3b85fb5a68fe461c1660af9ea514/pyinstaller-5.0.tar.gz"
  sha256 "0b7f1a09e1ae617867d4e9b56285dd670bcf0b1362b272c96a933b0195fce226"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740ef935ddbb23c9f7d8683216a39552f8559e5c8b2ae3d9fba537d0cdf64f4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98c4b8c319e01ebd29ca27cbacc7609bb4d91b2f2ae4bea6d590febbe2d0efdd"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2a89157785024d6aa7719986ca9f80cbd34a8bae082f0b25a058371ec441c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9230d35f283ee959292e9a3cfb054a0700cdfd9b0021707cb0c0449ee5bd46e"
    sha256 cellar: :any_skip_relocation, catalina:       "afd84a5d4704140f8ae63cc9b1191403ab7df06beb8f01d3a9b40f0c9541500d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfe15293a25166a50961de5dca4d88bf3ff6b852e88eb52026554cd2ea86958"
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
    url "https://files.pythonhosted.org/packages/4c/c9/065f97b7e89dcb438ce3e270f3f28af5cba759f4127afe14ce6038701270/pyinstaller-hooks-contrib-2022.4.tar.gz"
    sha256 "b7f7da20e5b83c22219a21b8f849525e5f735197975313208f4e07ff9549cdaf"
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
