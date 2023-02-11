class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/63/20/cfb61921d7db3e8473440091ac99ae900357f26197502ab7ec9ff6473ca5/pyinstaller-5.8.0.tar.gz"
  sha256 "314fb883caf3cbf06adbea2b77671bb73c3481568e994af0467ea7e47eb64755"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "823828ca6aadde3b1a4685cb11d6a9bf3bcf1a185e6f0a4304f95847aba3901a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266d09acc9f1c88a388fa5d3ecadaf9b0054a283d672204eed5162c75a853450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1cc4e3e4a87461a95838f87a46f2255fefed4376d90ae0518a71aac26164ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "8fcdfa877ad4beca01bd033fbfbe65aa4dd43ae0cfcf5e11f8d87898e803eb5c"
    sha256 cellar: :any_skip_relocation, monterey:       "2389b3af97e424f1384e4390640000a0419ba44181a3367b623cc199f049d45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "621d4f5f79f2197b50356a5c6d30344682e04cc7a2d469f0c55141a4da81f279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41bd653076fd4b12d7588dadb5b659c25a5c6e0dd87cb5bcc0c013411fd316af"
  end

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
    url "https://files.pythonhosted.org/packages/70/ca/a8c03acf2f249a3675cac6a322e70fa4ea200f40590cf72cb4cd322bfeb3/pyinstaller-hooks-contrib-2022.15.tar.gz"
    sha256 "73fd4051dc1620f3ae9643291cd9e2f47bfed582ade2eb05e3247ecab4a4f5f3"
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
