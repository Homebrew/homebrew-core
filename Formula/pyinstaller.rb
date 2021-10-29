class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/90/8c/3aa36c18d2f05dc85d810b3fdd23dbadee15375b15c75533247347b4bb86/pyinstaller-4.6.tar.gz"
  sha256 "0fe1fdd6851663d378e85692709506d5d7c6dfc59105315ab78ba99dac689ca3"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f058fc00f78f21c13c44363525fb51bfcaea8635dd1a41b4ec925aea7e24b167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4272eaf2d73796e1509b1df73cd8d16b94a6355b27abac02f0ce0d17741260f4"
    sha256 cellar: :any_skip_relocation, monterey:       "ac4600bcb99833a76b182b928ecf04ec6a9af5827d87d48071d5a027f61b7991"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d32eca7f24a755e73cdc63f64f1c2bbd813ee16d91d5f883a77cad112ea3a7"
    sha256 cellar: :any_skip_relocation, catalina:       "fcd5279e9d8fc01bdd988a3ad7ebb3bb13162f0221d1651746beb55570824c92"
    sha256 cellar: :any_skip_relocation, mojave:         "14b0ce068eb56e05a847cc72834163072ef3da7bfdbbd517d2f82255164ed226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd94131c0b3c6bc8938c00b9c0a9dd1e00a7718b3a92fde29babaf60c5f5e600"
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
