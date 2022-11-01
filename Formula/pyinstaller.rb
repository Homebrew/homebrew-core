class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/36/95/32b67f2b6945c34400524284e582025269cf992c6994ff36ed8899e4cf58/pyinstaller-5.6.2.tar.gz"
  sha256 "865025b6809d777bb0f66d8f8ab50cc97dc3dbe0ff09a1ef1f2fd646432714fc"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f188b71288f69b44b18fa5831697a401a8d78ca1c479dbe0191fc35de67fd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce0817d591c8400819c5eec307ab48e83696a815be0120e88d528f17199c8796"
    sha256 cellar: :any_skip_relocation, monterey:       "90e5051a486de3e6326bfe666df23b165af58baff5bfc3d0a2db36e98609356c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b57b984db75f5f8ac8efd33300b7cf90f2387b6e8be75079c1041d400c1b304"
    sha256 cellar: :any_skip_relocation, catalina:       "25aac8c610e42d4941fa20a29e111470d7bb5983478936197a10cf8fb31d37c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7e1938e5be99b582f215497c80a567d3fd10e669f4cd910dedd7f6474c8f9a"
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
    url "https://files.pythonhosted.org/packages/ca/f1/dbe83d578ca8c652c8452fcb08b92f35e318a5e66daf619b70593ba53fae/pyinstaller-hooks-contrib-2022.11.tar.gz"
    sha256 "2e1870350bb9ef2e09c1c1bb30347eb3185c5ef38c040ed04190d6d0b4b5df62"
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
