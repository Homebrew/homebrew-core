class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/f8/25/41d6be08d65bdc5126e86d854f5767397483acf360f2c95c890e3fa96a31/pyinstaller-6.14.2.tar.gz"
  sha256 "142cce0719e79315f0cc26400c2e5c45d9b6b17e7e0491fee444a9f8f16f4917"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8fcce6d4ceb27eaf2a3bf46f96ac87992befe2e35dc75e4f93be672bfc3ce2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b1659ad4ddee15f2fb0e571afbf3f44892af3f39811ed89d0b8270ffc0a9ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da6d5965ac65ad3a7e34637c4672004f01dbe9ea97d558347267f2cc61a34f4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bef6bee9eec84bd57d654a256cdfd50325bdba1db9845c87cdf5157c255f92"
    sha256 cellar: :any_skip_relocation, ventura:       "dad9761093d531248b426be55b0e22d64c70a7eea30ebc6073b49bf5cbf07662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16df0896355e6737fe751cde3e3860b82f4506b608ce7d2db5d744a4fe06b57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37343e683fafc16eed927f4f706acbb759790ff4af43b0695b52ebbe04b4247e"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/5f/ff/e3376595935d5f8135964d2177cd3e3e0c1b5a6237497d9775237c247a5d/pyinstaller_hooks_contrib-2025.5.tar.gz"
    sha256 "707386770b8fe066c04aad18a71bc483c7b25e18b4750a756999f7da2ab31982"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.13", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
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
