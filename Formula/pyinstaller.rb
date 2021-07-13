class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/56/68/fcf288abb7985d17c4d5802aa76cbc6e00cd85d084230338cf4ef8696a38/pyinstaller-4.4.tar.gz"
  sha256 "af3ef0b9f265a2d3859357a25ab16743fbb6143c89fd7c3570cb84b8d24db0ba"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "292e4fe62bbd4c2c59af1e78efd679928b0c4e01cd089547d70382fec7c990fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "06978aedae4293f278b0f729727ce21b612ababb90339b76dd3ad2a58fd42eb1"
    sha256 cellar: :any_skip_relocation, catalina:      "b8f2786b1aa933009cd69f8254e4529f55f1fc07b398b34a0473a07619e28c64"
    sha256 cellar: :any_skip_relocation, mojave:        "d2270fa53effbfb5842f5e66d89fbbcde05acc125056ec4660f5e717119855f7"
  end

  depends_on "python@3.9"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/22/5a/ac50b52581bbf0d8f6fd50ad77d20faac19a2263b43c60e7f3af8d1ec880/altgraph-0.17.tar.gz"
    sha256 "1f05a47122542f97028caf78775a095fbe6a2699b5089de8477eb583167d69aa"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/0d/fe/61e8f6b569c8273a8f2dd73921738239e03a2acbfc55be09f8793261f269/macholib-1.14.tar.gz"
    sha256 "0c436bc847e7b1d9bda0560351bf76d7caf930fb585a828d13608839ef42c432"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/eb/fa/fe062e44776ab8edb4ac62daca1a02bb744ebdd556ec7a75c19c717e80b4/pyinstaller-hooks-contrib-2021.2.tar.gz"
    sha256 "7f5d0689b30da3092149fc536a835a94045ac8c9f0e6dfb23ac171890f5ea8f2"
  end

  def install
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
