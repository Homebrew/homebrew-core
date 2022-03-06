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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740ef935ddbb23c9f7d8683216a39552f8559e5c8b2ae3d9fba537d0cdf64f4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98c4b8c319e01ebd29ca27cbacc7609bb4d91b2f2ae4bea6d590febbe2d0efdd"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2a89157785024d6aa7719986ca9f80cbd34a8bae082f0b25a058371ec441c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9230d35f283ee959292e9a3cfb054a0700cdfd9b0021707cb0c0449ee5bd46e"
    sha256 cellar: :any_skip_relocation, catalina:       "afd84a5d4704140f8ae63cc9b1191403ab7df06beb8f01d3a9b40f0c9541500d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfe15293a25166a50961de5dca4d88bf3ff6b852e88eb52026554cd2ea86958"
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
