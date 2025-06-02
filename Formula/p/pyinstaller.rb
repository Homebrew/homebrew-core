class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/a8/b1/2949fe6d3874e961898ca5cfc1bf2cf13bdeea488b302e74a745bc28c8ba/pyinstaller-6.13.0.tar.gz"
  sha256 "38911feec2c5e215e5159a7e66fdb12400168bd116143b54a8a7a37f08733456"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51eb5d4a30eb9d14b11702b4117b82349c522009a5c8033d9a65f40cf8c5c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2dae95c589e9932968ccf27a812a2a531d6817ca3accc62feb1a87b590a09fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54b817a369f17b6f98a88782c20f262c8d6fc77c5790d1690ba51e54ce38b280"
    sha256 cellar: :any_skip_relocation, sonoma:        "e57d2505fc506b0dccbc951b8b7ad225b36766284603b6381ad2430ee42d2ec4"
    sha256 cellar: :any_skip_relocation, ventura:       "c7aeac3531d4596f3a0755334e2964cdd31d7b4929e08a69c65fed78ff978256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7dd4fbb05f686d3e1b0a9cc27d0f567db9da655900d23d7af9f7aa1daff73fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86bada842aee68d6e21123209a0e375a88a219a63a8f7934a82d5ca7b792396"
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
    url "https://files.pythonhosted.org/packages/e3/94/dfc5c7903306211798f990e6794c2eb7b8685ac487b26979e9255790419c/pyinstaller_hooks_contrib-2025.4.tar.gz"
    sha256 "5ce1afd1997b03e70f546207031cfdf2782030aabacc102190677059e2856446"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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
