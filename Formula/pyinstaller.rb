class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  # Change to main site when back online: https://github.com/pyinstaller/pyinstaller/issues/6490
  homepage "https://pyinstaller.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b0/e6/e5760666896739115b0e4538a42cdd895215581618ec885ad043dd35ee57/pyinstaller-4.10.tar.gz"
  sha256 "7749c868d2e2dc84df7d6f65437226183c8a366f3a99bb2737785625c3a3cca1"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e37e356d8f7554859df7d46af29732923d04ddd1dc0964eec74509a032c1f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9ef19b7a81f5db483c2eacc4425a2452959b3049f4a1d0f548d5a4da72a66b9"
    sha256 cellar: :any_skip_relocation, monterey:       "998829efbe384441f8e6794d1e620d2efef68594cb5b65f22ae27c4b6a14b614"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a4b01402213dd5147e542196f441791cd1a73a9343eb2befc60b5fe2168944"
    sha256 cellar: :any_skip_relocation, catalina:       "ad140aad953af656a6f960b2216c2ea27350eae57902e03f553778aa0a088b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d815f3caf526f2869265822908b0d30d65434de321583f7adacc0a114fe33ad"
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
    url "https://files.pythonhosted.org/packages/07/92/1b5fb9a40cba9c87db8242fef50797b1408156c31960279be2d7652a82e1/pyinstaller-hooks-contrib-2022.2.tar.gz"
    sha256 "ab1d14fe053016fff7b0c6aea51d980bac6d02114b04063b46ef7dac70c70e1e"
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
