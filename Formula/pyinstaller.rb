class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/18/9e/dbee87c405633be8ae926520d5e91c29cd76c969328ad4c724e6983e2b58/pyinstaller-5.4.1.tar.gz"
  sha256 "2a09e6bd6e121eb1a71fadb223797dc502e4fd4168931c31a5f87faa10eb5b4c"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc879916bc470dc4c5c3eec197e0057ab90a69efbe5aafc0d32f3d12fa7cacdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24c226c28916c5df8ef9216519e22cbee14266c01c7b6fb6c19da4db1658e309"
    sha256 cellar: :any_skip_relocation, monterey:       "9f72f8724175e0f51944f7de2985e6046d784929cf412e9e1a1f001302346aa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c9ace791b25fb59fd88bc495645964c17ae6047e0b53b53338b0c03a793800"
    sha256 cellar: :any_skip_relocation, catalina:       "3f324b76d6c3b8795af864cc9eb3d36095241c737b67810f7879016d3164b9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d774577388b63cc650a68885988d2a70c0e747224a91d6f49cc38a55b71821f"
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
