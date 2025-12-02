class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/01/80/9e0dad9c69a7cfd4b5aaede8c6225d762bab7247a2a6b7651e1995522001/pyinstaller-6.17.0.tar.gz"
  sha256 "be372bd911392b88277e510940ac32a5c2a6ce4b8d00a311c78fa443f4f27313"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e96b3f523e51044da85f3ca341760a4930c5318177c2b6163d63ba2b169d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85dc53558ea9cda946226a12cc6727820888ca4e776ccfa55c5dc3dc222f4dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f7395eb516a67fa349bbb82420310cfb5d1a36fb9bd639b6ef030a93dfc5d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba44b64a6b5d3847ee413843c7a2440641ea284fa3447742b84ac3ace187ae59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539a78aeb61eeefc2d2f45d688b7fd928bfd01011d729fbb72776388e7186b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d76b4e71317267ec560e4931bf7428c784929c0ef8653f7624bbc24d90c2021"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/26/4f/e33132acdb8f732978e577b8a0130a412cbfe7a3414605e3fd380a975522/pyinstaller_hooks_contrib-2025.10.tar.gz"
    sha256 "a1a737e5c0dccf1cf6f19a25e2efd109b9fec9ddd625f97f553dac16ee884881"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
