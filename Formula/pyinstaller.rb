class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/00/ca/58dd68fee42490be1c86c9e912fc9ad0bf44c72edd882397ad11c21fbecb/pyinstaller-4.7.tar.gz"
  sha256 "2c7f4810dc5272ec1b388a7f1ff6b56d38653c1b0c9ac2d9dd54fa06b590e372"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9a325f14a65b46ef37dfa0f8dfb0a334e1d6b2b742eb5d1e67f39ac7e54da7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46b9b146124db5572609c6a203e372ec95ba03d8e855dc4e2726784eef57604d"
    sha256 cellar: :any_skip_relocation, monterey:       "d6cd1f9961eb843c4fd6a5009211439384fbbd928c3c7a4d893c3a73543e302b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5e2604077ab354e8c3bf1ce57a27ac608da7076bcd9d941f8188f343ee13ee"
    sha256 cellar: :any_skip_relocation, catalina:       "b87a8cbd74279493c96dac6bfaa176eb418ad78b9fcf01f8257647e832a6c1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74455c8f9aff4e74c9c37837b35e42d3df0892324553609447a9eb5e90bd8aa8"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/c2/c1/09a06315332fc6c46539a1df57195c21ba944517181f85f728559f1d0ecb/macholib-1.15.2.tar.gz"
    sha256 "1542c41da3600509f91c165cb897e7e54c0e74008bd8da5da7ebbee519d593d2"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/a6/81/0a27c73014cbc9cc5623fd32f570d3daff7ad88999ecb4317cc6c6fd9db7/pyinstaller-hooks-contrib-2021.3.tar.gz"
    sha256 "169b09802a19f83593114821d6ba0416a05c7071ef0ca394f7bfb7e2c0c916c8"
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
