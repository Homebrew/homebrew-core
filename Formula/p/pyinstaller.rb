class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/55/d4/54f5f5c73b803e6256ea97ffc6ba8a305d9a5f57f85f9b00b282512bf18a/pyinstaller-6.11.1.tar.gz"
  sha256 "491dfb4d9d5d1d9650d9507daec1ff6829527a254d8e396badd60a0affcb72ef"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8052aa74552ec718de23f417304d6a9398f04e3f5fa561771c728b34a0edfa74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30d4fb9ee32eb5fd4a34126deadaab56ab4b16bcf44e8c9b2c569d21e59ce5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "760f8bb9d5458554315f1473605230bc3b59ee16e0239c7d16e9d9d4788be5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "81d25c2b49a062cdfda2296c419401751f0369ed03532f4e851cc6be9532773f"
    sha256 cellar: :any_skip_relocation, ventura:       "20dd57ee3e134800991d2f58bf6285741b50b456e169adcc54deb577e86efc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e68541f4edcb4280d1d630d02c2635c7d2eab5b08a42fcb8ecca0288e9a6a55"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/73/6a/9d0057e312b85fbd17a79e1c1955d115fd9bbc78b85bab757777c8ef2307/pyinstaller_hooks_contrib-2024.10.tar.gz"
    sha256 "8a46655e5c5b0186b5e527399118a9b342f10513eb1425c483fa4f6d02e8800c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ed/22/a438e0caa4576f8c383fa4d35f1cc01655a46c75be358960d815bfbb12bd/setuptools-75.3.0.tar.gz"
    sha256 "fba5dd4d766e97be1b1681d98712680ae8f2f26d7881245f2ce9e40714f1a686"
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
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
