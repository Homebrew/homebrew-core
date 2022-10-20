class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/1e/d7/214b25c912d5f7d9c31d266821a8be6a35df80535056fe83997688721927/pyinstaller-5.5.tar.gz"
  sha256 "88993dfc6429dce8dd1f9a73c08e259af71dd3a227d3002ccb8e959151757dc3"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae8a3eae097af19ed836085cbdf197f5a940336a741cbc97bce1d270cc9527f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e594fac49f198911bc291b21d897c2b8baa25c7beeb1972d005ad038afd6167a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce87b8fb34040e0fa886924f679383d7457211c5f1eb042cdd437eb05659af0"
    sha256 cellar: :any_skip_relocation, big_sur:        "465906d979124a607213c832ec7163d4f04e594c3859571ca461547a7ec9e11a"
    sha256 cellar: :any_skip_relocation, catalina:       "e0045fd6e0d8bdcfda45fca6d6681be48b90f9bfb96ffe521abff50537449406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b2cf4db18a31541d8310e12e2cab015073ad7547110642d8c5686b3879c416"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/8d/46/5b21e3eedc41fe0a8522e409ab2c71ebf137eab0f9e632c5213e76f97b7e/pyinstaller-hooks-contrib-2022.10.tar.gz"
    sha256 "e5edd4094175e78c178ef987b61be19efff6caa23d266ade456fc753e847f62e"
  end

  def install
    cd "bootloader" do
      system "python3.10", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
