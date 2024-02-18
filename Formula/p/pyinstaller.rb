class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/83/5c/752340e73c195e21112eaec094d2d176705e4c18dc42a8357b68bb0dd693/pyinstaller-6.4.0.tar.gz"
  sha256 "1bf608ed947b58614711275a7ff169289b32560dc97ec748ebd5fa8bdec80649"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "182f84802df47a8f6f812da97ac5ef55bdf4a03c690439edd42fcc8f17ef0f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8107ff5d44abd9b264555a1e1cd569f77180bc212bb8dd3f5692ee32be8a81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f30bb6ad46fcc163ee3123ca52c09fdf21a1c50fda0988f2e0620c718a739e07"
    sha256 cellar: :any_skip_relocation, sonoma:         "30c1b71a9e7af8fb62394da93183667c3df9c6ff521f007a774b6e263cf89301"
    sha256 cellar: :any_skip_relocation, ventura:        "736face34dd63726a75c772a8aa9bcc5e097072872a86404e0e9513b4f3261dc"
    sha256 cellar: :any_skip_relocation, monterey:       "c0c2651222ee164a0776873e446a094ef74dc1c0b2729ae7cbf8cdb9c0ad7dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b29f4e046b744dcb1877a462a4101134c7b024f1781b4be12d58cc0dad39cba"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/c4/d0/276175694985ae97497f176591a724c226257ad93acf1901896a218aed76/pyinstaller-hooks-contrib-2024.1.tar.gz"
    sha256 "51a51ea9e1ae6bd5ffa7ec45eba7579624bf4f2472ff56dba0edc186f6ed46a6"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
