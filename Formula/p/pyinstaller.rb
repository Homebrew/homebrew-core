class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/a2/c8/2802bbf8abe0312ba1250f0c20158db202135ed0475c88e19944ef11cdad/pyinstaller-6.8.0.tar.gz"
  sha256 "3f4b6520f4423fe19bcc2fd63ab7238851ae2bdcbc98f25bc5d2f97cc62012e9"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e91deaecefee6df058317884240d1aedf4091a771cde6df055f3e98f65905538"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad3de1cf86bbab722700168cbce6696fee0686045cde8b9eb08615ecf199ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c888861300d3681f46a1e9e189c4d30e347da13970e4ffaafd757244dbf5a429"
    sha256 cellar: :any_skip_relocation, sonoma:         "905dfd8a39eaafad4ab911164275a688a7e78faaa8de758ad27d98fb4ca0913f"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c770e93ba307049f4e9f3a5c5c9404b28dbf891baf4859e8b8b4d88296a60c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4104f652125214946896759549a7ba419b3d39d2582a6a678a9256a2b4d2d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a785b117736e5ae85b1cdd06fc6c2d89125aa2ab1697b392fcf4c7d22f6863"
  end

  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/b1/04/fd321018585c0751e8a4f857470e95d188aa80bc48002303cf26e5711d7d/pyinstaller_hooks_contrib-2024.7.tar.gz"
    sha256 "fd5f37dcf99bece184e40642af88be16a9b89613ecb958a8bd1136634fc9fac5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
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
